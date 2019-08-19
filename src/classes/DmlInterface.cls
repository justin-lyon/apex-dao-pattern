public interface DmlInterface {
	void insertRecords(List<SObject> newRecords);
	void updateRecords(List<SObject> records);
	void upsertRecords(List<SObject> records);
	void deleteRecords(List<SObject> records);
}
