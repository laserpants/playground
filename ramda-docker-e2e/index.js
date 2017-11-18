import Future     from 'fluture'
import Ramda      from 'ramda'
import containers from './config.json'
import docker     from './docker'

const { parallel } = Future

const { 
  apply, 
  bind, 
  compose, 
  curry, 
  differenceWith, 
  flatten, 
  has, 
  lensIndex,
  map, 
  over, 
  pair, 
  partition, 
  path, 
  pipe,
  pluck, 
  startsWith, 
  unapply, 
  zipWith 
} = Ramda

const pluckTags = compose(flatten, pluck('RepoTags'))

const pickAbsent = differenceWith(
  compose(
    apply(startsWith),
    over(lensIndex(0), path(['config', 'Image'])),
    pair
  )
)

const flatPairMap = 
  unapply(
    curry(
      compose(
        flatten,
        zipWith(map)
      )
    )
  )

docker.images()
  .map(pipe(
    pluckTags,
    pickAbsent(containers),
    partition(has('build')),
    flatPairMap(
      docker.build, 
      docker.pull 
    )
  ))
  .chain(parallel(1))
  .fork(console.error, console.log)
