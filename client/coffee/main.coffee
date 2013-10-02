require
  shim:
    'app':
      deps: [
        'libs/angular'
      ]
    'bootstrap': deps: ['app']
    'routes': deps: [
        'app'
        , 'controllers/main'
    ]
  [
    'app'
    'require'
    'controllers/main'
  ], (require) ->
    require ['bootstrap']