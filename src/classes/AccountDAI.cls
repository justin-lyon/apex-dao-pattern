public interface AccountDAI extends DmlInterface {
	List<Account> queryLimittedAccounts(Integer limitter);
	List<Account> searchAccounts(String searchString);
}
