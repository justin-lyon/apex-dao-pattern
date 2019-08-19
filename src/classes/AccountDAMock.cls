@isTest
public inherited sharing class AccountDAMock extends DmlBaseMock implements AccountDAI {
	public Map<Id, Account> Accounts;
	public Boolean IsSuccess = true;

	private static final Schema.SObjectType ACCOUNT_TYPE = Schema.Account.SObjectType;
	private static final String ACCOUNT_NAME = 'Account';

	public AccountDAMock() {
		super(new Map<Id, Account>(), ACCOUNT_TYPE);
		this.Accounts = (Map<Id, Account>)super.Records;
	}

	public List<Account> queryLimittedAccounts(Integer limitter) {
		isQueryException();
		List<Account> foundAccounts = new List<Account>();
		Integer count = 0;
		for(Account acc : Accounts.values()) {
			if (count < AccountDA.MAX_RESULTS) {
				foundAccounts.add(acc);
			}
			count++;
		}
		return foundAccounts;
	}

	public List<Account> searchAccounts(String searchString) {
		isQueryException();
		List<Account> foundAccounts = new List<Account>();
		Integer count = 0;
		for(Account acc : Accounts.values()) {
			if (count < AccountDA.MAX_RESULTS && acc.Name.contains(searchString)) {
				foundAccounts.add(acc);
			}
		}
		return foundAccounts;
	}

	private void isQueryException() {
		if (!IsSuccess) {
			throw new QueryException('Forced Exception from AccountDAMock.');
		}
	}

	private void isDmlException() {
		if (!IsSuccess) {
			throw new DmlException('Forced Exception from AccountDAMock.');
		}
	}
}
