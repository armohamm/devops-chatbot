import boto3
import time
from Slack_Lambda_Layer import *

def trigger_outbound_call(escalation_target, incident):
    connect = boto3.client('connect', region_name='eu-central-1')
    response = connect.start_outbound_voice_contact(
        InstanceId = '736d65e0-6ce5-4210-9d44-55c366ea9a16',
        ContactFlowId = 'c1a120ab-98fd-4f52-911d-484c442e1a42',
        DestinationPhoneNumber = escalation_target['number'],
        SourcePhoneNumber = '+448081649919',
        Attributes = {
            'message': incident['message'],
            'escalationTargetName': escalation_target['name'],
            'incidentIds': incident['id']
        },
    )
    return response

def get_users_from_ddb(team):
    ddb = boto3.client('dynamodb')
    users = ddb.scan(
        TableName = 'user',
        ScanFilter = {
            'teams': {
                'AttributeValueList': [{'S': team.lower()}],
                'ComparisonOperator': 'CONTAINS'
            }
        }
    )
    return users['Items']

def get_incident_status(id):
    dynamodb = boto3.client('dynamodb')
    response = dynamodb.get_item(
        TableName = 'alert-log',
        Key = {
            'messageID': {
                'S': id
            }
        }
    )
    return response['Item']['currentStatus']['S']

def lambda_handler(event, context):
    escalationTarget = event['escalationTarget']
    incident = event['incident']

    # first contact attempt (phone)
    trigger_outbound_call(escalationTarget, incident)
    time.sleep(30)

    # second contact attempt (phone)
    if get_incident_status(incident['id']) == 'open':
        trigger_outbound_call(escalationTarget, incident)
        time.sleep(30)

        # third contact attempt (slack)
        if get_incident_status(incident['id']) == 'open':
            channel_name = 'incident_' + incident['id']
            try:
                channel = create_channel(channel_name)
                set_channel_topic(channel['id'], 'Incident message: ' + incident['message'])
                set_channel_purpose(channel['id'], 'Resolving incident with message: ' + incident['message'])
                post_message(channel['id'], 'I created this channel for you to handle the incident with the message: "' + incident['message'] + '".\n\nLet\'s resolve this issue as fast as possible! :rocket:')
            except SlackException as e:
                if e.error == 'name_taken':
                    channel = [c for c in get_channels() if c['name'] == channel_name][0]
                    if channel['is_archived']:
                        unarchive_channel(channel['id'])
                    join_channel(channel_name)
            users = get_users_from_ddb(escalationTarget['team'])
            if len(users) == 0:
                return { 'statusCode': 500 }
            for user in users:
                try:
                    invite_to_channel(channel['id'], user['slackUserID']['S'])
                except SlackException as e:
                    if e.error in ['already_in_channel', 'user_not_found', 'cant_invite_self']:
                        pass
                    else:
                        return {'statusCode': 500, 'error': 'The method "' + e.method + '" failed with error "' + e.error + '"'}
            post_message(channel['id'], 'Welcome, team ' + escalationTarget['team'] + '! :wave:')

    return { 'statusCode': 200 }