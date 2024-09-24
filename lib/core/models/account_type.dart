/// The account type.
/// See [GnuCash Source](https://github.com/Gnucash/gnucash/blob/5.8/libgnucash/engine/Account.h)
enum AccountType {
  /// The bank account type denotes a savings
  /// or checking account held at a bank.
  /// Often interest bearing.
  bank,

  /// The cash account type is used to denote a
  /// shoe-box or pillowcase stuffed with *
  /// cash.
  cash,

  /// The Credit card account is used to denote
  /// credit (e.g. amex) and debit (e.g. visa,
  /// mastercard) card accounts
  credit,

  /// asset (and liability) accounts indicate
  /// generic, generalized accounts that are
  /// none of the above.
  asset,

  /// liability (and asset) accounts indicate
  /// generic, generalized accounts that are
  /// none of the above.
  liability,

  /// Stock accounts will typically be shown in
  /// registers which show three columns:
  /// price, number of shares, and value.
  @Deprecated("Stock accounts are not supported")
  stock,

  /// Mutual Fund accounts will typically be
  /// shown in registers which show three
  /// columns: price, number of shares, and
  /// value.
  mutual,

  /// The currency account type indicates that
  /// the account is a currency trading
  /// account.  In many ways, a currency
  /// trading account is like a stock *
  /// trading account. It is shown in the
  /// register with three columns: price,
  /// number of shares, and value. Note:
  /// Since version 1.7.0, this account is *
  /// no longer needed to exchange currencies
  /// between accounts, so this type is
  /// DEPRECATED.
  @Deprecated("Currency accounts are not supported")
  currency,

  /// Income accounts are used to denote
  /// income
  income,

  /// Expense accounts are used to denote
  /// expenses.
  expense,

  /// Equity account is used to balance the
  /// balance sheet.
  equity,

  /// A/R account type
  @Deprecated("A/R accounts are not supported")
  receivable,

  /// A/P account type
  @Deprecated("A/P accounts are not supported")
  payable,

  /// Account used to record multiple commodity transactions.
  /// This is not the same as CURRENCY above.
  /// Multiple commodity transactions have splits in these
  /// accounts to make the transaction balance in each
  /// commodity as well as in total value.
  @Deprecated("Trading accounts are not supported")
  trading,
}
