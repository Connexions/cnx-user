define [
  'jquery'
  'underscore'
  'backbone'
  'cs!models'
  'cs!views'
  'less!styles/main.less'
], ($, _, Backbone, models, views) ->

  router = new Backbone.Router
  router.route '', 'index', ->
    view = new views.SplashView
    $('[role=main]').html view.render().el
  router.route 'register', 'register', ->
    # Pass in the authentication identity provider collection.
    providers = new models.IdentityProviders().fetch
      success: (collection, response) ->
        console.log "#{collection.length} identity providers available"
      error: (collection, response) ->
        console.log "Something when wrong while trying to fetch the list of identity providers."
    view = new views.RegistrationView collection: providers
    $('[role=main]').html view.render().el
  router.route 'login', 'login', ->
    # Pass in the authentication identity provider collection.
    ##providers = models.IdentityProviders
    view = new views.LoginView  ##collection: providers
    $('[role=main]').html view.render().el
  router.route 'users/:id', 'profile', (id) ->
    ##profile = models.Profile
    view = new views.ProfileView   ##model: profile
    $('[role=main]').html view.render().el

  # Intercept all clicks on 'a' tags.
  $(document).on 'click', 'a:not([data-bypass])', (e) ->
    external = new RegExp('^((f|ht)tps?:)?//')
    href = $(@).attr('href')

    e.preventDefault()

    if external.test(href)
      window.open(href, '_blank')
    else
      router.navigate(href, {trigger: true})

  # Start the HTML5 history/pushState interface, which allows for
  #   URL navigation.
  Backbone.history.start pushState: true

  return router
