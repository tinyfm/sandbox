'use strict';

var Mopidy = require('mopidy');
var when = require('when');
var utils = require('util');

function logErrors(err){
  console.error(err);
}

var mopidy = new Mopidy({
  callingConvention: 'by-position-or-by-name',
  webSocketUrl: 'ws://' + (process.env.HOST || 'localhost') + ':6680/mopidy/ws/'
});

mopidy.on("state:online", function () {
  accumulateTracksInDirs([], [null])
  .then(function(trackUris){
    return mopidy.library.search({ uris: trackUris }).then(function(results){
      console.log(utils.inspect(results[0].tracks));
    })
  })
  .then(process.exit.bind(process, 0));
}, logErrors);

var getTracksFromRefs = getTypeFromRefs.bind(null, 'track');
var getDirsFromRefs = getTypeFromRefs.bind(null, 'directory');

function getTypeFromRefs(type, refs){
  return refs.filter(function(ref){
    return ref.type === type;
  })
  .map(function(ref){
    return ref.uri;
  });
}

function accumulateTracksInDirs(allTracks, dirs){
  return when.all(dirs.map(function(dir){ return mopidy.library.browse({ uri: dir }) }))
    .spread(function(results){
      if (!results){
        return allTracks;
      }

      var tracks = allTracks.concat(getTracksFromRefs(results));
      var dirs = getDirsFromRefs(results);

      return accumulateTracksInDirs(tracks, dirs);
    })
}