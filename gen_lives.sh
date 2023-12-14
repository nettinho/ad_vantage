mix phx.gen.live Campaings Campaign campaigns name description:text filename
mix phx.gen.live Campaings Channel channels name
mix phx.gen.live Campaings Variation variations name description orientation width:integer height:integer margin:integer language has_logo:boolean tone target
mix phx.gen.live Campaings CampaignChannel campaigns_channels campaign_id:references:campaigns channel_id:references:channels
mix phx.gen.live Campaings CampaignVariation campaign_variations campaign_id:references:campaigns variation_id:references:variations filename explanation
mix phx.gen.live Campaings Validation validations campaign_variation_id:references:campaign_variations approved:boolean explanation

mix phx.gen.live Prompts Prompt prompts name is_default:boolean content:map