# ResDerainNet

## Overview
Under severe weather conditions, most outdoor vision systems can be affected by heavy rain and fog. For example, in a rainy day, autonomous vehicles are difficult to determine how to navigate due to the degraded visual quality of images. In this paper, we address a single-image rain removal problem (de-raining). Compared with video based methods, single-image based methods are challenging because of less temporal information. Although many existing methods have tackled this problem, they suffer from overfitting, over-smoothing and unnatural hue change. To solve these problems, we propose a residual network for de-raining called ``ResDerainNet''. Based on the deep convolutional neural networks, we learn the mapping relationship between rainy and residual images from data. In addition, we synthesize a variety of rainy images for training our network. Specifically, we mainly focus on the composite models as well as orientations and scales of rain streaks. Experiments show that the proposed method is applicable to a wide range of images. Ours also achieves better performance on both synthetic and real-world images than state-of-the-art methods.

![net_architecture.png](https://qiita-image-store.s3.amazonaws.com/0/238733/4201579a-04cf-1ef2-86f6-4dd6d29a9c9d.png)
<img src="https://qiita-image-store.s3.amazonaws.com/0/238733/dc272717-b7e8-7e3b-a316-9b37daf15fdb.png" width="500">
## Demo
- De-rain:
`demo_derain.m`
- Generating rain noise:
`demo_synthesize.m`

## Installation
- [MATLAB R2018a](https://ww2.mathworks.cn/en/products/new_products/release2018a.html)
- [caffe version 1.0.0-rc3](http://caffe.berkeleyvision.org/)

## Contributions
- A residual deep network is introduced to remove rain noise.
Unlike the plane deep network which learns the mapping relationship between noisy and clean images, we learn the relationship between rainy and residual images from data.
This speeds up the training process and improves the de-raining performance.


- An automatic rain noise generator is introduced to obtain synthetic rain noise.  Most de-raining methods create rain noise by using Photoshop. Since synthetic rain noise has many parameters, it is difficult to automatically adjust these parameters. In our method, we can easily change some parameters on MATLAB, which saves time and effort to get natural rain noise.

- A combination of linear additive composite model and screen blend model is proposed to make synthetic rainy images.  In order for the training network to be applicable to a wide range of rainy images, only one composite model is not enough. Our experimental results show that a combination of these models achieves better performance than using either model.


## Author

[takuro-matsui](https://github.com/takuro-matsui)

If you have any questions, please feel free to send us an e-mail matsui@tkhm.elec.keio.ac.jp.
