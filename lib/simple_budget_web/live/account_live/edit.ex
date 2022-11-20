defmodule SimpleBudgetWeb.AccountLive.Edit do
  use SimpleBudgetWeb, :live_view
  require Logger

  def mount(params, session, socket) do
    account = SimpleBudget.Accounts.get(session, params)
    changeset = SimpleBudget.Account.changeset(account)

    {:ok,
     socket
     |> assign(%{page_title: "Accounts"})
     |> assign(%{changeset: changeset, account: account, identity: session["identity"]})
     |> assign(%{
       spendable_today: SimpleBudget.Goals.spendable_today(%{"identity" => session["identity"]})
     })}
  end

  def handle_event("validate", %{"account" => params}, socket) do
    changeset = SimpleBudget.Account.changeset(socket.assigns.account, params)
    total = SimpleBudget.Goals.spendable(%{"identity" => socket.assigns.identity})

    value =
      case params["balance"] |> Decimal.parse() do
        {decimal, ""} -> decimal
        _ -> Decimal.new("0")
      end

    total =
      case params["debt"] do
        "true" -> Decimal.sub(total, value)
        "false" -> Decimal.add(total, value)
        _ -> total
      end

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(
       :spendable_today,
       SimpleBudget.Goals.spendable_today(%{"identity" => socket.assigns.identity}, total)
     )}
  end

  def handle_event("save", %{"account" => params}, socket) do
    changeset = SimpleBudget.Account.changeset(socket.assigns.account, params)

    case changeset.valid? do
      false ->
        {:noreply, socket |> assign(:changeset, changeset)}

      true ->
        Logger.info("saving changeset: #{changeset |> inspect()}")
        SimpleBudget.Accounts.save(changeset)
        {:noreply, socket |> push_navigate(to: "/accounts")}
    end
  end
end
