@isTest
private class AccountDATest {
	private static final Integer MAX_RECORD_COUNT = AccountDA.MAX_RESULTS * 2;
	private static final String ACCOUNT_NAME = 'The Council of Ricks';

	@TestSetup
	static void makeData() {
		List<Account> accounts = new List<Account>();
		accounts.add(new Account(
			Name = ACCOUNT_NAME));

		for(Integer i = 0; i < MAX_RECORD_COUNT - 1; i++) {
			accounts.add(new Account(
				Name = 'Test Account ' + i));
		}
		insert accounts;
	}

	static TestMethod void queryLimittedAccounts_given5_shouldGet5Accounts() {
		AccountDA accessor = new AccountDA();
		Integer limitter = 5;

		Test.startTest();

			List<Account> accounts = accessor.queryLimittedAccounts(limitter);

		Test.stopTest();

		System.assertEquals(limitter, accounts.size(), 'Should only recieve ' + AccountDA.MAX_RESULTS + ' Accounts.');
	}

	static TestMethod void searchAccounts_givenString_shouldGetOneAccount() {
		Account theCouncil = [
			SELECT Id
			FROM Account
			WHERE Name = :ACCOUNT_NAME
			LIMIT 1];
		// SOSL in Apex Tests requires setting the output by List of Record Ids.
		Test.setFixedSearchResults(new List<Id> { theCouncil.Id });

		AccountDA accessor = new AccountDA();
		String searchString = ACCOUNT_NAME;

		Test.startTest();

			List<Account> accounts = accessor.searchAccounts(searchString);

		Test.stopTest();

		System.assert(!accounts.isEmpty(), 'Should have accounts list.');
		System.assertEquals(1, accounts.size(), 'Should have only one Account.');
		System.assertEquals(ACCOUNT_NAME, accounts[0].Name, 'The Account Name should be: ' + ACCOUNT_NAME);
	}

	static TestMethod void mockEnvironment_givenPassByReference_changesShouldReflectBetweenDAMockAndBaseMock() {
		AccountDAMock mock = new AccountDAMock();
		Id accountId = mock.Builder.getMockId();
		mock.Accounts.put(accountId, new Account(
			Id = accountId,
			Name = 'Test Mock Account Record'));

		List<Account> baseRecords = mock.getRecords();
		System.assertEquals(mock.Accounts.values()[0].Id, baseRecords[0].Id);

		mock.deleteRecords(new List<Account> { new Account(Id = accountId) });

		System.assert(mock.Accounts.isEmpty());
		System.assert(mock.getRecords().isEmpty());
	}
}
