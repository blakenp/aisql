import json
from openai import OpenAI
import os
from time import time
import psycopg2
from dotenv import load_dotenv
load_dotenv()

print("Running db_bot.py!")

connection_string = "put your supabase connection string here"

try:
    postgres_conn = psycopg2.connect(connection_string)
    postgres_cursor = postgres_conn.cursor()

    print("Connected to the PostgreSQL database!")
except Exception as e:
    print(f"Error connecting to PostgreSQL database: {e}")

fdir = os.path.dirname(__file__)
def getPath(fname):
    return os.path.join(fdir, fname)

setupSqlScriptPath = getPath("setup.sql")
try:
    with open(setupSqlScriptPath, "r") as sqlFile:
        setupSqlScript = sqlFile.read()
    print("Loaded setup.sql schema:")
except Exception as e:
    print(f"Error loading setup.sql: {e}")
    exit(1)

def runSql(query):
    try:
        postgres_cursor.execute(query)
        result = postgres_cursor.fetchall()
        postgres_conn.commit()
        return result
    except Exception as e:
        postgres_conn.rollback()
        raise e

# OPENAI
configPath = getPath("config.json")
print(configPath)
with open(configPath) as configFile:
    config = json.load(configFile)

openAiClient = OpenAI(api_key = config["openaiKey"])

def getChatGptResponse(content):
    stream = openAiClient.chat.completions.create(
        model="gpt-4o",
        messages=[{"role": "user", "content": content}],
        stream=True,
    )

    responseList = []
    for chunk in stream:
        if chunk.choices[0].delta.content is not None:
            responseList.append(chunk.choices[0].delta.content)

    result = "".join(responseList)
    return result


# strategies
commonSqlOnlyRequest = "Give me a sqlite select statement that answers the question. Only respond with sqlite syntax. If there is an error do not explain it!"
# Double-shot strategy with example
strategies = {
    "zero_shot": (
        "SQL Schema:\n"
        + setupSqlScript + "\n"
        + commonSqlOnlyRequest
    ),
    "single_domain_double_shot": (
        "SQL Schema:\n"
        + setupSqlScript
        + "\n"
        + "\nExample question: In which room is the Amulet of Wisdom?\n"
        + "Example SQL:\n"
        + "```sql\n"
        + "SELECT r.room_id, r.name\n"
        + "FROM public.room r\n"
        + "JOIN public.room_belongings rb ON r.room_id = rb.room_id\n"
        + "JOIN public.item i ON rb.item_id = i.item_id\n"
        + "WHERE i.name = 'Amulet of Wisdom';\n"
        + "```\n"
        + "Now answer this question in this format: "
        + commonSqlOnlyRequest
    )
}

questions = [
    "Which players have items",
    "Which room as multiple monsters in it?",
    "Which of the monsters currently in a room has the most attack power?",
    "Which rooms still have their lights turned on?",
    "What are all the rooms that currently have players in them?",
    "Which items still haven't been collected by players yet?",
    "Which ability has the highest danger level?",
    "Which room has no players in it?",
    "Which rooms have ghosts in them and what are the ghost's names and favorite foods?"
    # "I need insert sql into my tables can you provide good unique data?"
]

def sanitizeForJustSql(value):
    gptStartSqlMarker = "```sql"
    gptEndSqlMarker = "```"
    if gptStartSqlMarker in value:
        value = value.split(gptStartSqlMarker)[1]
    if gptEndSqlMarker in value:
        value = value.split(gptEndSqlMarker)[0]

    return value

for strategy in strategies:
    responses = {"strategy": strategy, "prompt_prefix": strategies[strategy]}
    questionResults = []
    for question in questions:
        print(question)
        error = "None"
        try:
            sqlSyntaxResponse = getChatGptResponse(strategies[strategy] + " " + question)
            sqlSyntaxResponse = sanitizeForJustSql(sqlSyntaxResponse)
            print(sqlSyntaxResponse)
            queryRawResponse = str(runSql(sqlSyntaxResponse))
            print(queryRawResponse)
            friendlyResultsPrompt = "I asked a question \"" + question +"\" and the response was \""+queryRawResponse+"\" Please, just give a concise response in a more friendly way? Please do not give any other suggests or chatter."
            friendlyResponse = getChatGptResponse(friendlyResultsPrompt)
            print(friendlyResponse)
        except Exception as err:
            error = str(err)
            print(err)

        questionResults.append({
            "question": question, 
            "sql": sqlSyntaxResponse, 
            "queryRawResponse": queryRawResponse,
            "friendlyResponse": friendlyResponse,
            "error": error
        })

    responses["questionResults"] = questionResults

    with open(getPath(f"response_{strategy}_{time()}.json"), "w") as outFile:
        json.dump(responses, outFile, indent = 2)
            

postgres_cursor.close()
postgres_conn.close()
print("Done!")