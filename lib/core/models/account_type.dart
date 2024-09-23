/// The account type.
/// See [GnuCash Code](https://github.com/Gnucash/gnucash/blob/5.8/libgnucash/engine/Account.h)
enum AccountType {
  /// < The bank account type denotes a savings
  ///   or checking account held at a bank.
  ///   Often interest bearing.
  BANK,

  /// < The cash account type is used to denote a
  ///   shoe-box or pillowcase stuffed with *
  ///   cash.
  CASH,

  /// < The Credit card account is used to denote
  ///   credit (e.g. amex) and debit (e.g. visa,
  ///   mastercard) card accounts
  CREDIT,

  /// < asset (and liability) accounts indicate
  ///   generic, generalized accounts that are
  ///   none of the above.
  ASSET,

  /// < liability (and asset) accounts indicate
  ///   generic, generalized accounts that are
  ///   none of the above.
  LIABILITY,

  /// < Stock accounts will typically be shown in
  ///   registers which show three columns:
  ///   price, number of shares, and value.
  @Deprecated("Stock accounts are not supported")
  STOCK,

  /// < Mutual Fund accounts will typically be
  ///   shown in registers which show three
  ///   columns: price, number of shares, and
  ///   value.
  MUTUAL,

  /// < The currency account type indicates that
  ///   the account is a currency trading
  ///   account.  In many ways, a currency
  ///   trading account is like a stock *
  ///   trading account. It is shown in the
  ///   register with three columns: price,
  ///   number of shares, and value. Note:
  ///   Since version 1.7.0, this account is *
  ///   no longer needed to exchange currencies
  ///   between accounts, so this type is
  ///   DEPRECATED.
  @Deprecated("Currency accounts are not supported")
  CURRENCY,

  /// < Income accounts are used to denote
  ///   income
  INCOME,

  /// < Expense accounts are used to denote
  ///   expenses.
  EXPENSE,

  /// < Equity account is used to balance the
  ///   balance sheet.
  EQUITY,

  /// < A/R account type
  @deprecated
  RECEIVABLE,
  @deprecated

  /// < A/P account type
  PAYABLE,
  @deprecated

  /// < The hidden root account of an account tree.
  ROOT,

  /// /// < Account used to record multiple commodity transactions.
  //  ///   This is not the same as CURRENCY above.
  //  ///   Multiple commodity transactions have splits in these
  //  ///   accounts to make the transaction balance in each
  //  ///   commodity as well as in total value.
  @deprecated
  TRADING,
  @deprecated
  NUM_ACCOUNT_TYPES,

  /// < stop here; the following types
  /// just aren't ready for prime time

/* bank account types */

  /// < bank account type -- don't use this
  ///   for now, see NUM_ACCOUNT_TYPES
  @deprecated
  CHECKING,

  /// < bank account type -- don't use this for
  ///   now, see NUM_ACCOUNT_TYPES
  @deprecated
  SAVINGS,

  /// < bank account type -- don't use this
  ///   for now, see NUM_ACCOUNT_TYPES
  @deprecated
  MONEYMRKT,
  /**< line of credit -- don't use this for
   *   now, see NUM_ACCOUNT_TYPES  */
  @deprecated
  CREDITLINE,
}
