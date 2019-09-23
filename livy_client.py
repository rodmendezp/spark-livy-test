from livy.client import LivyClient
from livy.models import SessionKind

livy_endpoint = 'http://localhost:8998'
jars = ['s3://my-bucket/Person.jar']
client = LivyClient(livy_endpoint)
session = client.create_session(SessionKind.PYSPARK, jars=jars)

