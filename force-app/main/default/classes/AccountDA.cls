public inherited sharing class AccountDA extends DmlBase implements AccountDAI {
	public static final Integer MAX_RESULTS = 5;

	public List<Account> queryLimittedAccounts(Integer limitter) {
		limitter = Integer.valueOf(limitter);
		return [
			SELECT Id,
				Name
			FROM Account
			ORDER BY CreatedDate ASC
			LIMIT :limitter];
	}

	public List<Account> searchAccounts(String searchString) {
		String escapedTerm = String.escapeSingleQuotes(searchString) + '*';

		List<List<SObject>> results = [
			FIND :escapedTerm IN ALL FIELDS
			RETURNING
				Account (Id, Name)
			LIMIT :MAX_RESULTS];

		return results[0];
	}
}
