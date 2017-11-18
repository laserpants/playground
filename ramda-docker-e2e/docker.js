import Docker              from 'dockerode'
import tar                 from 'tar-fs'
import Future, { encaseP } from 'fluture'
import Ramda               from 'ramda'

const { bind, isNil } = Ramda

const docker = new Docker()

const images = encaseP(bind(docker.listImages, docker))
const buildImage = bind(docker.buildImage, docker)
const pullImage  = bind(docker.pull, docker)

const build = ({ config: { Image: img }, build }) => Future((rej, res) => 
  buildImage(
    tar.pack(build), { t: img }, (err, stream) => 
      isNil(err)
      ? stream.on('end', () => res(img)).pipe(process.stdout)
      : rej(err) 
  )
)

const pull = ({ config : { Image: img } }) => Future((rej, res) =>
  pullImage(img, (err, stream) => 
    isNil(err)
    ? stream.on('end', () => res(img)).pipe(process.stdout)
    : rej(err) 
  )
)

export default {
  images, 
  build, 
  pull
}
