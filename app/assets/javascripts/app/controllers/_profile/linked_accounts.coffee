class Index extends App.ControllerSubContent
  requiredPermission: 'user_preferences.linked_accounts'
  header: 'Linked Accounts'
  events:
    'click .js-remove': 'remove'

  constructor: ->
    super
    @render()

  render: =>
    auth_provider_all = {
      facebook: {
        url:    '/auth/facebook'
        name:   'Facebook'
        config: 'auth_facebook'
      },
      twitter: {
        url:    '/auth/twitter'
        name:   'Twitter'
        config: 'auth_twitter'
      },
      linkedin: {
        url:    '/auth/linkedin'
        name:   'LinkedIn'
        config: 'auth_linkedin'
      },
      github: {
        url:    '/auth/github'
        name:   'GitHub'
        config: 'auth_github'
      },
      gitlab: {
        url:    '/auth/gitlab'
        name:   'GitLab'
        config: 'auth_gitlab'
      },
      google_oauth2: {
        url:    '/auth/google_oauth2'
        name:   'Google'
        config: 'auth_google_oauth2'
      },
      oauth2: {
        url:    '/auth/oauth2'
        name:   'OAuth2'
        config: 'auth_oauth2'
      },
    }
    auth_providers = {}
    for key, provider of auth_provider_all
      if @Config.get(provider.config) is true || @Config.get(provider.config) is 'true'
        auth_providers[key] = provider

    @html App.view('profile/linked_accounts')(
      user:           App.Session.get()
      auth_providers: auth_providers
    )

  remove: (e) =>
    e.preventDefault()
    provider = $(e.target).data('provider')
    uid      = $(e.target).data('uid')

    # get data
    @ajax(
      id:          'account'
      type:        'DELETE'
      url:         "#{@apiPath}/users/account"
      data:        JSON.stringify(provider: provider, uid: uid)
      processData: true
      success:     @success
      error:       @error
    )

  success: (data, status, xhr) =>
    @notify(
      type: 'success'
      msg:  App.i18n.translateContent('Successful!')
    )
    update = =>
      @render()
    App.User.full(@Session.get('id'), update, true)

  error: (xhr, status, error) =>
    @render()
    data = JSON.parse(xhr.responseText)
    @notify(
      type: 'error'
      msg:  App.i18n.translateContent(data.message)
    )

App.Config.set('LinkedAccounts', { prio: 4000, name: 'Linked Accounts', parent: '#profile', target: '#profile/linked', controller: Index, permission: ['user_preferences.linked_accounts'] }, 'NavBarProfile')
