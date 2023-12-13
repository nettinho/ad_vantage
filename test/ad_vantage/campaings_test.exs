defmodule AdVantage.CampaingsTest do
  use AdVantage.DataCase

  alias AdVantage.Campaings

  describe "campaigns" do
    alias AdVantage.Campaings.Campaign

    import AdVantage.CampaingsFixtures

    @invalid_attrs %{name: nil, filename: nil, description: nil}

    test "list_campaigns/0 returns all campaigns" do
      campaign = campaign_fixture()
      assert Campaings.list_campaigns() == [campaign]
    end

    test "get_campaign!/1 returns the campaign with given id" do
      campaign = campaign_fixture()
      assert Campaings.get_campaign!(campaign.id) == campaign
    end

    test "create_campaign/1 with valid data creates a campaign" do
      valid_attrs = %{
        name: "some name",
        filename: "some filename",
        description: "some description"
      }

      assert {:ok, %Campaign{} = campaign} = Campaings.create_campaign(valid_attrs)
      assert campaign.name == "some name"
      assert campaign.filename == "some filename"
      assert campaign.description == "some description"
    end

    test "create_campaign/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaings.create_campaign(@invalid_attrs)
    end

    test "update_campaign/2 with valid data updates the campaign" do
      campaign = campaign_fixture()

      update_attrs = %{
        name: "some updated name",
        filename: "some updated filename",
        description: "some updated description"
      }

      assert {:ok, %Campaign{} = campaign} = Campaings.update_campaign(campaign, update_attrs)
      assert campaign.name == "some updated name"
      assert campaign.filename == "some updated filename"
      assert campaign.description == "some updated description"
    end

    test "update_campaign/2 with invalid data returns error changeset" do
      campaign = campaign_fixture()
      assert {:error, %Ecto.Changeset{}} = Campaings.update_campaign(campaign, @invalid_attrs)
      assert campaign == Campaings.get_campaign!(campaign.id)
    end

    test "delete_campaign/1 deletes the campaign" do
      campaign = campaign_fixture()
      assert {:ok, %Campaign{}} = Campaings.delete_campaign(campaign)
      assert_raise Ecto.NoResultsError, fn -> Campaings.get_campaign!(campaign.id) end
    end

    test "change_campaign/1 returns a campaign changeset" do
      campaign = campaign_fixture()
      assert %Ecto.Changeset{} = Campaings.change_campaign(campaign)
    end
  end

  describe "channels" do
    alias AdVantage.Campaings.Channel

    import AdVantage.CampaingsFixtures

    @invalid_attrs %{name: nil}

    test "list_channels/0 returns all channels" do
      channel = channel_fixture()
      assert Campaings.list_channels() == [channel]
    end

    test "get_channel!/1 returns the channel with given id" do
      channel = channel_fixture()
      assert Campaings.get_channel!(channel.id) == channel
    end

    test "create_channel/1 with valid data creates a channel" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Channel{} = channel} = Campaings.create_channel(valid_attrs)
      assert channel.name == "some name"
    end

    test "create_channel/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaings.create_channel(@invalid_attrs)
    end

    test "update_channel/2 with valid data updates the channel" do
      channel = channel_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Channel{} = channel} = Campaings.update_channel(channel, update_attrs)
      assert channel.name == "some updated name"
    end

    test "update_channel/2 with invalid data returns error changeset" do
      channel = channel_fixture()
      assert {:error, %Ecto.Changeset{}} = Campaings.update_channel(channel, @invalid_attrs)
      assert channel == Campaings.get_channel!(channel.id)
    end

    test "delete_channel/1 deletes the channel" do
      channel = channel_fixture()
      assert {:ok, %Channel{}} = Campaings.delete_channel(channel)
      assert_raise Ecto.NoResultsError, fn -> Campaings.get_channel!(channel.id) end
    end

    test "change_channel/1 returns a channel changeset" do
      channel = channel_fixture()
      assert %Ecto.Changeset{} = Campaings.change_channel(channel)
    end
  end

  describe "variations" do
    alias AdVantage.Campaings.Variation

    import AdVantage.CampaingsFixtures

    @invalid_attrs %{
      name: nil,
      description: nil,
      width: nil,
      target: nil,
      orientation: nil,
      height: nil,
      margin: nil,
      has_logo: nil,
      tone: nil
    }

    test "list_variations/0 returns all variations" do
      variation = variation_fixture()
      assert Campaings.list_variations() == [variation]
    end

    test "get_variation!/1 returns the variation with given id" do
      variation = variation_fixture()
      assert Campaings.get_variation!(variation.id) == variation
    end

    test "create_variation/1 with valid data creates a variation" do
      valid_attrs = %{
        name: "some name",
        description: "some description",
        width: 42,
        target: "some target",
        orientation: "some orientation",
        height: 42,
        margin: 42,
        has_logo: true,
        tone: "some tone"
      }

      assert {:ok, %Variation{} = variation} = Campaings.create_variation(valid_attrs)
      assert variation.name == "some name"
      assert variation.description == "some description"
      assert variation.width == 42
      assert variation.target == "some target"
      assert variation.orientation == "some orientation"
      assert variation.height == 42
      assert variation.margin == 42
      assert variation.has_logo == true
      assert variation.tone == "some tone"
    end

    test "create_variation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaings.create_variation(@invalid_attrs)
    end

    test "update_variation/2 with valid data updates the variation" do
      variation = variation_fixture()

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        width: 43,
        target: "some updated target",
        orientation: "some updated orientation",
        height: 43,
        margin: 43,
        has_logo: false,
        tone: "some updated tone"
      }

      assert {:ok, %Variation{} = variation} = Campaings.update_variation(variation, update_attrs)
      assert variation.name == "some updated name"
      assert variation.description == "some updated description"
      assert variation.width == 43
      assert variation.target == "some updated target"
      assert variation.orientation == "some updated orientation"
      assert variation.height == 43
      assert variation.margin == 43
      assert variation.has_logo == false
      assert variation.tone == "some updated tone"
    end

    test "update_variation/2 with invalid data returns error changeset" do
      variation = variation_fixture()
      assert {:error, %Ecto.Changeset{}} = Campaings.update_variation(variation, @invalid_attrs)
      assert variation == Campaings.get_variation!(variation.id)
    end

    test "delete_variation/1 deletes the variation" do
      variation = variation_fixture()
      assert {:ok, %Variation{}} = Campaings.delete_variation(variation)
      assert_raise Ecto.NoResultsError, fn -> Campaings.get_variation!(variation.id) end
    end

    test "change_variation/1 returns a variation changeset" do
      variation = variation_fixture()
      assert %Ecto.Changeset{} = Campaings.change_variation(variation)
    end
  end

  describe "campaigns_channels" do
    alias AdVantage.Campaings.CampaignChannel

    import AdVantage.CampaingsFixtures

    @invalid_attrs %{}

    test "list_campaigns_channels/0 returns all campaigns_channels" do
      campaign_channel = campaign_channel_fixture()
      assert Campaings.list_campaigns_channels() == [campaign_channel]
    end

    test "get_campaign_channel!/1 returns the campaign_channel with given id" do
      campaign_channel = campaign_channel_fixture()
      assert Campaings.get_campaign_channel!(campaign_channel.id) == campaign_channel
    end

    test "create_campaign_channel/1 with valid data creates a campaign_channel" do
      valid_attrs = %{}

      assert {:ok, %CampaignChannel{} = campaign_channel} =
               Campaings.create_campaign_channel(valid_attrs)
    end

    test "create_campaign_channel/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaings.create_campaign_channel(@invalid_attrs)
    end

    test "update_campaign_channel/2 with valid data updates the campaign_channel" do
      campaign_channel = campaign_channel_fixture()
      update_attrs = %{}

      assert {:ok, %CampaignChannel{} = campaign_channel} =
               Campaings.update_campaign_channel(campaign_channel, update_attrs)
    end

    test "update_campaign_channel/2 with invalid data returns error changeset" do
      campaign_channel = campaign_channel_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Campaings.update_campaign_channel(campaign_channel, @invalid_attrs)

      assert campaign_channel == Campaings.get_campaign_channel!(campaign_channel.id)
    end

    test "delete_campaign_channel/1 deletes the campaign_channel" do
      campaign_channel = campaign_channel_fixture()
      assert {:ok, %CampaignChannel{}} = Campaings.delete_campaign_channel(campaign_channel)

      assert_raise Ecto.NoResultsError, fn ->
        Campaings.get_campaign_channel!(campaign_channel.id)
      end
    end

    test "change_campaign_channel/1 returns a campaign_channel changeset" do
      campaign_channel = campaign_channel_fixture()
      assert %Ecto.Changeset{} = Campaings.change_campaign_channel(campaign_channel)
    end
  end

  describe "campaign_variations" do
    alias AdVantage.Campaings.CampaignVariation

    import AdVantage.CampaingsFixtures

    @invalid_attrs %{filename: nil, explanation: nil}

    test "list_campaign_variations/0 returns all campaign_variations" do
      campaign_variation = campaign_variation_fixture()
      assert Campaings.list_campaign_variations() == [campaign_variation]
    end

    test "get_campaign_variation!/1 returns the campaign_variation with given id" do
      campaign_variation = campaign_variation_fixture()
      assert Campaings.get_campaign_variation!(campaign_variation.id) == campaign_variation
    end

    test "create_campaign_variation/1 with valid data creates a campaign_variation" do
      valid_attrs = %{filename: "some filename", explanation: "some explanation"}

      assert {:ok, %CampaignVariation{} = campaign_variation} =
               Campaings.create_campaign_variation(valid_attrs)

      assert campaign_variation.filename == "some filename"
      assert campaign_variation.explanation == "some explanation"
    end

    test "create_campaign_variation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaings.create_campaign_variation(@invalid_attrs)
    end

    test "update_campaign_variation/2 with valid data updates the campaign_variation" do
      campaign_variation = campaign_variation_fixture()
      update_attrs = %{filename: "some updated filename", explanation: "some updated explanation"}

      assert {:ok, %CampaignVariation{} = campaign_variation} =
               Campaings.update_campaign_variation(campaign_variation, update_attrs)

      assert campaign_variation.filename == "some updated filename"
      assert campaign_variation.explanation == "some updated explanation"
    end

    test "update_campaign_variation/2 with invalid data returns error changeset" do
      campaign_variation = campaign_variation_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Campaings.update_campaign_variation(campaign_variation, @invalid_attrs)

      assert campaign_variation == Campaings.get_campaign_variation!(campaign_variation.id)
    end

    test "delete_campaign_variation/1 deletes the campaign_variation" do
      campaign_variation = campaign_variation_fixture()
      assert {:ok, %CampaignVariation{}} = Campaings.delete_campaign_variation(campaign_variation)

      assert_raise Ecto.NoResultsError, fn ->
        Campaings.get_campaign_variation!(campaign_variation.id)
      end
    end

    test "change_campaign_variation/1 returns a campaign_variation changeset" do
      campaign_variation = campaign_variation_fixture()
      assert %Ecto.Changeset{} = Campaings.change_campaign_variation(campaign_variation)
    end
  end

  describe "validations" do
    alias AdVantage.Campaings.Validation

    import AdVantage.CampaingsFixtures

    @invalid_attrs %{approved: nil, explanation: nil}

    test "list_validations/0 returns all validations" do
      validation = validation_fixture()
      assert Campaings.list_validations() == [validation]
    end

    test "get_validation!/1 returns the validation with given id" do
      validation = validation_fixture()
      assert Campaings.get_validation!(validation.id) == validation
    end

    test "create_validation/1 with valid data creates a validation" do
      valid_attrs = %{approved: true, explanation: "some explanation"}

      assert {:ok, %Validation{} = validation} = Campaings.create_validation(valid_attrs)
      assert validation.approved == true
      assert validation.explanation == "some explanation"
    end

    test "create_validation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaings.create_validation(@invalid_attrs)
    end

    test "update_validation/2 with valid data updates the validation" do
      validation = validation_fixture()
      update_attrs = %{approved: false, explanation: "some updated explanation"}

      assert {:ok, %Validation{} = validation} =
               Campaings.update_validation(validation, update_attrs)

      assert validation.approved == false
      assert validation.explanation == "some updated explanation"
    end

    test "update_validation/2 with invalid data returns error changeset" do
      validation = validation_fixture()
      assert {:error, %Ecto.Changeset{}} = Campaings.update_validation(validation, @invalid_attrs)
      assert validation == Campaings.get_validation!(validation.id)
    end

    test "delete_validation/1 deletes the validation" do
      validation = validation_fixture()
      assert {:ok, %Validation{}} = Campaings.delete_validation(validation)
      assert_raise Ecto.NoResultsError, fn -> Campaings.get_validation!(validation.id) end
    end

    test "change_validation/1 returns a validation changeset" do
      validation = validation_fixture()
      assert %Ecto.Changeset{} = Campaings.change_validation(validation)
    end
  end
end
