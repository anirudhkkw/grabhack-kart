object false

#Extend success message tag
extends 'shared/success.json.rabl'


node(:data) do
	{
	    :products => partial('v1/ads/ad_attributes', :object => @productInfoList)
    }
end