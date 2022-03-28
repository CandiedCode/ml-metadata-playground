from ml_metadata import metadata_store
from ml_metadata.proto import metadata_store_pb2


def connect_fake() -> metadata_store.MetadataStore:
    connection_config = metadata_store_pb2.ConnectionConfig()
    connection_config.fake_database.SetInParent() # Sets an empty fake database proto.
    return metadata_store.MetadataStore(connection_config)

def connect_mysql() -> metadata_store.MetadataStore:
    connection_config = metadata_store_pb2.ConnectionConfig()
    connection_config.mysql.host = '0.0.0.0'
    connection_config.mysql.port = 3306
    connection_config.mysql.database = 'metadata'
    connection_config.mysql.user = 'test'
    connection_config.mysql.password = 'secret'
    return metadata_store.MetadataStore(connection_config)



def create_artifact_types(store):
    data_type = metadata_store_pb2.ArtifactType()
    data_type.name = "DataSet"
    data_type.properties["day"] = metadata_store_pb2.INT
    data_type.properties["split"] = metadata_store_pb2.STRING
    data_type_id = store.put_artifact_type(data_type)

    model_type = metadata_store_pb2.ArtifactType()
    model_type.name = "SavedModel"
    model_type.properties["version"] = metadata_store_pb2.INT
    model_type.properties["name"] = metadata_store_pb2.STRING
    model_type_id = store.put_artifact_type(model_type)

    print(f"DataType: {data_type_id}")
    print(f"SavedModel: {model_type_id}")

    # Query all registered Artifact types.
    artifact_types = store.get_artifact_types()
    print(artifact_types)


if __name__ == '__main__':
    #store = connect_fake()
    store = connect_mysql()
    create_artifact_types(store)
