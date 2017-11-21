defmodule Stripe.Account do
  @moduledoc """
  Work with Stripe Connect account objects.

  You can:

  - Retrieve your own account
  - Retrieve an account with a specified `id`

  This module does not yet support managed accounts.

  Stripe API reference: https://stripe.com/docs/api#account
  """
  use Stripe.Entity
  import Stripe.Request

  @type decline_charge_on :: %{
    avs_failure: boolean,
    cvc_failure: boolean
  }

  @type legal_entity :: %{
    additional_owners: [legal_entity_additional_owner] | nil,
    address: legal_entity_address,
    address_kana: legal_entity_japan_address | nil,
    address_kanji: legal_entity_japan_address | nil,
    business_name: String.t | nil,
    business_name_kana: String.t | nil,
    business_name_kanji: String.t | nil,
    business_tax_id_provided: boolean,
    business_vat_id_provided: boolean,
    dob: legal_entity_dob,
    first_name: String.t | nil,
    first_name_kana: String.t | nil,
    first_name_kanji: String.t | nil,
    gender: String.t | nil,
    last_name: String.t | nil,
    last_name_kana: String.t | nil,
    last_name_kanji: String.t | nil,
    maiden_name: String.t | nil,
    personal_address: legal_entity_address,
    personal_address_kana: legal_entity_japan_address | nil,
    personal_address_kanji: legal_entity_japan_address | nil,
    personal_id_number_provided: boolean,
    phone_number: String.t | nil,
    ssn_last_4_provided: String.t,
    tax_id_registar: String.t,
    type: :individual | :company | nil,
    verification: legal_entity_verification
  }

  @type legal_entity_additional_owner :: %{
    address: legal_entity_address,
    dob: legal_entity_dob,
    first_name: String.t | nil,
    last_name: String.t | nil,
    maiden_name: String.t | nil,
    verification: legal_entity_verification
  }

  @type legal_entity_address :: %{
    city: String.t | nil,
    country: String.t | nil,
    line1: String.t | nil,
    line2: String.t | nil,
    postal_code: String.t | nil,
    state: String.t | nil
  }

  @type legal_entity_dob :: %{
    day: 1..31 | nil,
    month: 1..12 | nil,
    year: pos_integer | nil
  }

  @type legal_entity_japan_address :: %{
    city: String.t | nil,
    country: String.t | nil,
    line1: String.t | nil,
    line2: String.t | nil,
    postal_code: String.t | nil,
    state: String.t | nil,
    town: String.t | nil
  }

  @type legal_entity_verification :: %{
    details: String.t | nil,
    details_code: :scan_corrupt | :scan_not_readable | :scan_failed_greyscale |
                  :scan_not_uploaded | :scan_id_type_not_supported |
                  :scan_id_country_not_supported | :scan_name_mismatch |
                  :scan_failed_other | :failed_keyed_identity | :failed_other |
                  nil,
    document: Stripe.id | Stripe.FileUpload.t | nil,
    status: :unverified | :pending | :verified
  }

  @type tos_acceptance :: %{
    date: Stripe.timestamp | nil,
    ip: String.t | nil,
    user_agent: String.t | nil
  }

  @type verification :: %{
    disabled_reason: :"rejected.fraud" | :"rejected.terms_of_service" |
                     :"rejected.listed" | :"rejected.other" | :fields_needed |
                     :listed | :under_review | :other | nil,
    due_by: Stripe.timestamp | nil,
    fields_needed: [String.t]
  }

  @type t :: %__MODULE__{
    id: Stripe.id,
    object: String.t,
    business_name: String.t | nil,
    business_url: String.t | nil,
    charges_enabled: boolean,
    country: String.t,
    debit_negative_balances: boolean,
    decline_charge_on: decline_charge_on,
    default_currency: String.t,
    details_submitted: boolean,
    display_name: String.t | nil,
    email: String.t | nil,
    external_accounts: Stripe.List.of(Stripe.BankAccount.t | Stripe.Card.t),
    legal_entity: legal_entity,
    metadata: Stripe.Types.metdata,
    payout_schedule: Stripe.Types.transfer_schedule,
    payout_statement_descriptor: String.t | nil,
    payouts_enabled: boolean,
    product_description: String.t | nil,
    statement_descriptor: String.t | nil,
    support_email: String.t | nil,
    support_phone: String.t | nil,
    timezone: String.t | nil,
    tos_acceptance: tos_acceptance,
    transfers_enabled: boolean | nil,
    type: :standard | :express | :custom,
    verification: verification
  }

  defstruct [
    :id,
    :object,
    :business_name,
    :business_url,
    :charges_enabled,
    :country,
    :debit_negative_balances,
    :decline_charge_on,
    :default_currency,
    :details_submitted,
    :display_name,
    :email,
    :external_accounts,
    :legal_entity,
    :metadata,
    :payout_schedule,
    :payout_statement_descriptor,
    :payouts_enabled,
    :product_description,
    :statement_descriptor,
    :support_email,
    :support_phone,
    :timezone,
    :tos_acceptance,
    :transfers_enabled,
    :type,
    :verification
  ]

  from_json data do
    data
    |> cast_to_atom([:type])
    |> cast_path(
         [:legal_entity],
         fn legal_entity ->
           legal_entity
           |> cast_to_atom([:type])
         end
       )
    |> cast_path(
         [:payout_schedule],
         fn payout_schedule ->
           payout_schedule
           |> cast_to_atom([:interval])
         end
       )
    |> cast_path(
         [:verification],
         fn verification ->
           verification
           |> cast_to_atom([:disabled_reason])
         end
       )
  end

  @singular_endpoint "account"
  @plural_endpoint "accounts"

  @type create_params :: %{
    type: :standard | :express | :custom,
    account_token: String.t | nil,
    business_logo: String.t | nil,
    business_name: String.t | nil,
    business_primary_color: String.t | nil,
    business_url: String.t | nil,
    country: String.t | nil,
    debit_negative_balances: boolean | nil,
    decline_charge_on: decline_charge_on | nil,
    default_currency: String.t | nil,
    email: String.t | nil,
    external_account:
      Stripe.ExternalAccount.create_params_for_bank_account |
      Stripe.ExternalAccount.create_params_for_card |
      String.t |
      nil,
    legal_entity: legal_entity,
    metadata: Stripe.Types.metdata | nil,
    payout_schedule: Stripe.Types.transfer_schedule | nil,
    payout_statement_descriptor: String.t | nil,
    product_description: String.t | nil,
    statement_descriptor: String.t | nil,
    support_email: String.t | nil,
    support_phone: String.t | nil,
    support_url: String.t | nil,
    tos_acceptance: tos_acceptance | nil
  }

  @doc """
  Create an account.
  """
  @spec create(params, Stripe.options) :: {:ok, t} | {:error, Stripe.Error.t}
        when params: create_params
  def create(params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> cast_to_id([:coupon, :default_source, :source])
    |> make_request()
  end

  @doc """
  Retrieve your own account without options.
  """
  @spec retrieve :: {:ok, t} | {:error, Stripe.Error.t}
  def retrieve, do: retrieve([])

  @doc """
  Retrieve your own account with options.
  """
  @spec retrieve(list) :: {:ok, t} | {:error, Stripe.Error.t}
  def retrieve(opts) when is_list(opts), do: do_retrieve(@singular_endpoint, opts)

  @doc """
  Retrieve an account with a specified `id`.
  """
  @spec retrieve(binary, list) :: {:ok, t} | {:error, Stripe.Error.t}
  def retrieve(id, opts \\ []), do: do_retrieve(@plural_endpoint <> "/" <> id, opts)

  @spec do_retrieve(String.t, list) :: {:ok, t} | {:error, Stripe.Error.t}
  defp do_retrieve(endpoint, opts) do
    new_request(opts)
    |> put_endpoint(endpoint)
    |> put_method(:get)
    |> make_request()
  end

  @type update_params :: %{
    account_token: String.t | nil,
    business_logo: String.t | nil,
    business_name: String.t | nil,
    business_primary_color: String.t | nil,
    business_url: String.t | nil,
    country: String.t | nil,
    debit_negative_balances: boolean | nil,
    decline_charge_on: decline_charge_on | nil,
    default_currency: String.t | nil,
    email: String.t | nil,
    external_account:
      Stripe.ExternalAccount.create_params_for_bank_account |
      Stripe.ExternalAccount.create_params_for_card |
      String.t |
      nil,
    legal_entity: legal_entity,
    metadata: Stripe.Types.metdata | nil,
    payout_schedule: Stripe.Types.transfer_schedule | nil,
    payout_statement_descriptor: String.t | nil,
    product_description: String.t | nil,
    statement_descriptor: String.t | nil,
    support_email: String.t | nil,
    support_phone: String.t | nil,
    support_url: String.t | nil,
    tos_acceptance: tos_acceptance | nil
  }

  @doc """
  Update an account.

  Takes the `id` and a map of changes.
  """
  @spec update(Stripe.id | t, params, Stripe.options) :: {:ok, t} | {:error, Stripe.Error.t}
        when params: update_params
  def update(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  Delete an account.
  """
  @spec delete(Stripe.id | t, Stripe.options) :: {:ok, t} | {:error, Stripe.Error.t}
  def delete(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:delete)
    |> make_request()
  end

  @doc """
  Reject an account.

  Takes the `id` and `reason`.
  """
  @spec reject(Stripe.id | t, String.t, Stripe.options) :: {:ok, t} | {:error, Stripe.Error.t}
  def reject(id, reason, opts \\ []) do
    params = %{
      account: id,
      reason: reason
    }
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}/reject")
    |> put_method(:post)
    |> put_params(params)
    |> cast_to_id([:account])
    |> make_request()
  end

  @doc """
  List all connected accounts.
  """
  @spec list(params, Stripe.options) :: {:ok, Stripe.List.of(t)} | {:error, Stripe.Error.t}
        when params: %{
               created: Stripe.date_query,
               ending_before: t | Stripe.id,
               limit: 1..100,
               starting_after: t | Stripe.id
             }
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:ending_before, :starting_after])
    |> make_request()
  end

  @doc """
  Create a login link.
  """
  @spec create_login_link(Stripe.id | t, map, Stripe.options) :: {:ok, t} | {:error, Stripe.Error.t}
  def create_login_link(id, params, opts \\ []) do
    Stripe.LoginLink.create(id, params, opts)
  end
end
