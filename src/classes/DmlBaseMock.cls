public abstract class DmlBaseMock implements DmlInterface {
	protected Map<Id, SObject> Records;
	public MockSObjectBuilder Builder;

	private static final String ID_FIELD = 'Id';

	public DmlBaseMock(Map<Id, SObject> records, Schema.SObjectType objectType) {
		this.Records = records;
		this.builder = new MockSObjectBuilder(objectType);
	}

	public List<SObject> getRecords() {
		return this.Records.values();
	}

	public void insertRecords(List<SObject> newRecords) {
		for (SObject record : newRecords) {
			if (record.get(ID_FIELD) != null) {
				throw new DmlException('Cannot insert a record with an ID.');
			}
			Id recordId = builder.getMockId();
			record.put(ID_FIELD, recordId);
			this.Records.put((Id)recordId, record);
		}
	}

	public void updateRecords(List<SObject> records) {
		for (SObject record : records) {
			if (record.get(ID_FIELD) == null) {
				throw new DmlException('Records to update must have a record Id.');
			}
			this.Records.put((Id)record.get(ID_FIELD), record);
		}
	}

	public void upsertRecords(List<SObject> records) {
		for (SObject record : records) {
			if (record.get(ID_FIELD) == null) {
				Id recordId = builder.getMockId();
				record.put(ID_FIELD, recordId);
			}
			this.Records.put((Id)record.get(ID_FIELD), record);
		}
	}

	public void deleteRecords(List<SObject> records) {
		for (SObject record : records) {
			if (record.get(ID_FIELD) == null) {
				throw new DmlException('Records to delete must have a record Id.');
			}
			this.Records.remove((Id)record.get(ID_FIELD));
		}
	}
}
