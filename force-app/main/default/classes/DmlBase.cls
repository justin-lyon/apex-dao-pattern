/**
* @author Justin Lyon
* @date 2019-08-15
*
* @group data-layer
*
* @description Data Layer Base class for Generic SObject DML.
*		While methods accept Generic SObject Lists,
*		the runtime implementation must pass a list of a concrete SObject Type.
*/
public abstract class DmlBase implements DmlInterface {

	public void insertRecords(List<SObject> newRecords) {
		insert newRecords;
	}

	public void updateRecords(List<SObject> records) {
		update records;
	}

	/**
	* @description Upsert a Collection of Records
	* @param List<SObject> records - The Collection to be upserted.
	* @example
	* public class MyClass extends DmlImpl {}
	* MyClass instance = new MyClass();
	* List<Account> accounts = new List<Account>();
	* instance.upsertRecords(accounts);
	*/
	public void upsertRecords(List<SObject> records) {
		upsert records;
	}

	public void deleteRecords(List<SObject> records) {
		delete records;
	}
}
