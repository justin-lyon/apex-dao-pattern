@isTest
private class DmlBaseTest {
	private class DmlStub extends DmlBase {}
	static TestMethod void insertRecords_givenAccount_shouldGetId() {
		Account acc = new Account(
			Name = 'Test Account');

		DmlStub stub = new DmlStub();
		Test.startTest();

			stub.insertRecords(new List<Account> { acc });

		Test.stopTest();

		System.assertNotEquals(null, acc.Id);
	}

	static TestMethod void updateRecords_givenAccount_shouldGetUpdatedAccount() {
		String oldAccoountNumber = '123';
		String newAccountNumber = '456';

		Account acc = new Account(
			Name = 'Test Account',
			AccountNumber = oldAccoountNumber);

		insert acc;

		acc.AccountNumber = newAccountNumber;

		DmlStub stub = new DmlStub();
		Test.startTest();

			stub.updateRecords(new List<Account> { acc });

		Test.stopTest();

		System.assertNotEquals(null, acc.Id);
		Account updatedAccount = [SELECT AccountNumber FROM Account WHERE Id = :acc.Id];

		System.assertNotEquals(oldAccoountNumber, updatedAccount.AccountNumber);
		System.assertEquals(newAccountNumber, updatedAccount.AccountNumber);
	}

	static TestMethod void upsertRecords_givenNewAccount_shouldGetId() {
		Account acc = new Account(
			Name = 'Test Account');

		DmlStub stub = new DmlStub();
		Test.startTest();

			stub.upsertRecords(new List<Account> { acc });

		Test.stopTest();

		System.assertNotEquals(null, acc.Id);
	}

	static TestMethod void deleteRecords_givenOldAccount_shouldGetNullID() {
		Account acc = new Account(
			Name = 'Test Account');

		insert acc;

		DmlStub stub = new DmlStub();
		Test.startTest();

			stub.deleteRecords(new List<Account> { acc });

		Test.stopTest();

		List<Account> accounts = [SELECT Id FROM Account];
		System.assert(accounts.isEmpty());
	}
}
