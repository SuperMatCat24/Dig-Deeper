
purchase = new Sound
purchase.init 0.15, noteFreq(84), [0.3, 0], Sound.sawtoothWave

purchase2 = new Sound
purchase2.init 1, noteFreq(96), [0]*8 + range(0.4,0,-0.01), Sound.sineWave

purchase.mix purchase2

purchase3 = new Sound
purchase3.init 0.3, noteFreq(30), [1, 0] + [0]*30 + range(0.4,0,-0.01), Sound.noiseWave
purchase.mix purchase3

mine = new Sound
mine.init 0.2, 10, [0.3, 0], Sound.noiseWave

hit = new Sound
hit.init 0.15, [300, 0], [0.2, 0], Sound.triangleWave

hit2 = new Sound
hit2.init 0.15, [20, 0], [0.3, 0], Sound.noiseWave
hit.mix hit2

spawn = new Sound
spawn.init 0.1, [200, 0], [0.3, 0], Sound.noiseWave

shine = new Sound
shine.init 0.4, noteFreq(96), [0.1, 0.07, 0], Sound.sineWave

ranger = new Sound
ranger.init 0.6, noteFreq(72), 0.2, Sound.sineWave

ranger2 = new Sound
ranger2.init 0.6, noteFreq(77), 0.2, Sound.sineWave
ranger.mix ranger2

ranger3 = new Sound
ranger3.init 0.6, noteFreq(84), 0.2, Sound.sineWave
ranger.mix ranger3

machineSell = new Sound
machineSell.init 0.5, [900,800, 900, 700, 500, 300, 100], 0.2, Sound.sawtoothWave

machineSell2 = new Sound
machineSell2.init 0.5, 300, 0.2, Sound.noiseWave
machineSell.mix machineSell2

craft = new Sound
craft.init 0.7, 300, range(0.4,0,-0.01) + [0]*30 + range(0.4,0,-0.01) + [0]*30 + range(0.4,0,-0.01), Sound.noiseWave

craft2 = new Sound
craft2.init 0.7, 10, [0]*41 + [0.4]*30 + [0]*41 + [0.4]*30 + [0]*41 + [0.4]*30, Sound.noiseWave
craft.mix craft2