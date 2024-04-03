from openai import OpenAI
import re
#from main import Person

# BODGE BECAUSE ABOVE IS BROKEN



class Person:
    def __init__(self, id, text, devices):
        self.txt            = text
        self.devices        = devices   #devices
        self.id             = id        #user's device ID



client = OpenAI(
    api_key='       ' #TODO add key if needed
)


# [id, devices, text]
active_users = []


def analyze_relationship(conversation):
    #prep the msg for GPT
    prompt = f"How close are these 2 people on a scale of 0 to 3 and is this a real conversation or just 2 people speaking to themselves? \n" #and what is their relationship (potentially)
    for sentence in conversation:
        prompt += f"Person {sentence[0]} : {sentence[1]} \n"
    
    prompt += f"""I want your answer to be in the following format: \n number,boolean \n\n
    where the number is of type integer and it represents the closeness and the boolean value ("True" or "False") is wether it is a conversation or not.
    """
    #send the msg to GPT
    completion = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "user", "content": prompt},
        ]
    )

    #begin analysing the msg
    relationship = str(completion.choices[0].message).strip()

    match = re.search(r"content='(.*?)'", relationship)
    if match:
        relationship = match.group(1).split(',')  # Extract the content from the first capturing group
    else:
        print("GPT's response is invalid")
    
    print(f'\n\n\n\n\n\n Friendship level: {relationship[0]} \n\n\n\n\n\n')

    return relationship


def build_conversation(person1, person2):
    return [('A', person1.txt), ('B',person2.txt)]
    

def match_devices(person):
    related_people  = []
    for usr in active_users:
        if person.id in usr.devices and person.id != usr.id and usr.id in person.devices:
            related_people.append(usr)

    # with open('active_users.csv', 'r') as usr_db:
    #     for line in usr_db:
    #         if line.strip()[0] == '#':
    #             continue
    #         id, devices, text, pref = line.split(';')
    #         if person.id in devices and person.id != id and id in person.devices:
    #             person.id           = id
    #             person.devices      = devices.strip().split(',')
    #             person.preferences  = pref.strip().split(',')
    #             person.text         = text
    #             related_people.append(person)
    #raise exception ... no match
    return related_people

####################################    testing:    ####################################
# human = Person('7EJ6BJLTdPcZx6707LmcRcnvjzU2','bla bla', ['UNRELATED_DEVICE'], ['Email', 'Name'])
# print(match_devices(human))


##########################################################################################