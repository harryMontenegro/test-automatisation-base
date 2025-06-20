function() {
  var env = karate.env;
  if (!env) env = 'dev';

  var config = {
    env: env,
    baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters',
    idCharacter: ''
  };

  if (!karate.properties['idCharacter']) {
    var result = karate.callSingle('classpath:karate-test.feature@CreateNewCharacter', {
      baseUrl: config.baseUrl
    });
    karate.properties['idCharacter'] = result.createdCharacterId;
  }

  config.idCharacter = karate.properties['idCharacter'];

  return config;
}
