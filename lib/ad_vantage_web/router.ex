defmodule AdVantageWeb.Router do
  use AdVantageWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AdVantageWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AdVantageWeb do
    pipe_through :browser

    live "/", CampaignLive.Index, :index
    live "/campaigns", CampaignLive.Index, :index
    live "/campaigns/new", CampaignLive.New
    live "/campaigns/:id/edit", CampaignLive.Index, :edit
    live "/campaigns/:id", CampaignLive.Show, :show
    live "/campaigns/:id/show/edit", CampaignLive.Show, :edit
    live "/campaigns/:id/:channel_id/variations/new", CampaignLive.Show, :new_variation
    live "/campaigns/:id/variations/:variation_id", CampaignLive.ShowVariation, :show_variation

    live "/channels", ChannelLive.Index, :index
    live "/channels/new", ChannelLive.Index, :new
    live "/channels/:id/edit", ChannelLive.Index, :edit
    live "/channels/:id", ChannelLive.Show, :show
    live "/channels/:id/show/edit", ChannelLive.Show, :edit
    live "/channels/:id/variations/new", ChannelLive.Show, :new_variation
    live "/channels/:id/variations/:variation_id", ChannelLive.ShowVariation, :show_variation
    live "/channels/:id/variations/:variation_id/edit", ChannelLive.Show, :edit_variation

    live "/channels/:id/variations/:variation_id/show/edit",
         ChannelLive.ShowVariation,
         :edit_variation

    live "/validations", ValidationLive.Index, :index
    live "/validations/new", ValidationLive.Index, :new
    live "/validations/:id/edit", ValidationLive.Index, :edit
    live "/validations/:id", ValidationLive.Show, :show
    live "/validations/:id/show/edit", ValidationLive.Show, :edit

    live "/prompts", PromptLive.Index, :index
    live "/prompts/new", PromptLive.Index, :new
    live "/prompts/:id/edit", PromptLive.Index, :edit
    live "/prompts/:id", PromptLive.Show, :show
    live "/prompts/:id/show/edit", PromptLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", AdVantageWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ad_vantage, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AdVantageWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
