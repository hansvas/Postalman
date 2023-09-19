object DataModule1: TDataModule1
  Height = 142
  Width = 640
  object NomatimClient: TRESTClient
    BaseURL = 'https://nominatim.openstreetmap.org'
    Params = <>
    SynchronizedEvents = False
    Left = 40
    Top = 32
  end
  object RESTRequest: TRESTRequest
    Client = NomatimClient
    Params = <
      item
        Name = 'street'
      end
      item
        Name = 'city'
      end
      item
        Name = 'county'
      end
      item
        Name = 'country'
      end
      item
        Name = 'state'
      end
      item
        Name = 'postalcode'
      end
      item
        Name = 'Format'
        Value = 'json'
      end>
    Resource = 'search'
    Response = RESTResponse
    SynchronizedEvents = False
    Left = 168
    Top = 32
  end
  object RESTResponse: TRESTResponse
    Left = 288
    Top = 32
  end
end
