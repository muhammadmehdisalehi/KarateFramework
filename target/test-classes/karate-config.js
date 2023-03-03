function fn() {
  var env = karate.env; // get java system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'staging'; // a custom 'intelligent' default
  }
  var config = { // base config JSON
    environment: karate.env,
    cmsBaseURL: '',
    startingURL: '',
    authTokenFinal: '',
    endingUrl: '.api.x.com',
    accessTokenConfig: ''
  };

  if (env == 'dev') {
    // over-ride only those that need to be
    config.startingURL = 'https://';
    config.cmsBaseURL = 'https://dev.x.com';
  }
  else if (env == 'staging') {
    config.startingURL = 'https://staging.';
    config.cmsBaseURL = 'https://staging.x.com';
  }
  else if (env == 'qa') {
    config.startingURL = 'http://52.70.226.96:86';
  }
  // Called once function for authentication
  //var authenticationTokenResult = karate.callSingle('authenticationTokenCallSingle.feature');
  //config.authTokenFinal = authenticationTokenResult;
  // don't waste time waiting for a connection or if servers don't respond within 5 seconds
  karate.configure('connectTimeout', 2500);
  karate.configure('readTimeout', 2500);
  return config;
}