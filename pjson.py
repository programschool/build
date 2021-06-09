import json
import sys

value = json.loads(sys.argv[1])[sys.argv[2]]

print(value)
