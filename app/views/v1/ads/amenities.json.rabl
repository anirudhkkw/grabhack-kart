object false

#Extend success message tag
extends 'shared/success.json.rabl'


node(:data) do
	{
	    :amenities => partial('v1/ads/amenities_attributes', :object => @amenities)
    }
end