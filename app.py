import googleapiclient

compute = googleapiclient.discovery.build('compute', 'v1')

def list_instances(compute):
    result = compute.instances().list(project="gcp-kubernetes-278403", zone="us-east1-b").execute()
    return result['items'] if 'items' in result else None