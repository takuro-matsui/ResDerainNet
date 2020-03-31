# ResDerainNet
##Single-Image Rain Removal Using Residual Deep Learning (ICIP'18)
[[Paper Link](https://ieeexplore.ieee.org/document/8451612)] 

Most outdoor vision systems can be influenced by rainy weather conditions. In this paper, we address a rain removal problem from a single image. Some existing de-raining methods suffer from hue change due to neglect of the information in low frequency layer. Others fail in assuming enough rainy image models. To solve them, we propose a residual deep network architecture called ResDerainNet. Based on the deep convolutional neural network (CNN), we learn the mapping relationship between rainy and residual images from data. Furthermore, for training, we synthesize rainy images considering various rain models. Specifically, we mainly focus on the composite models as well as orientations and scales of rain streaks. The experiments demonstrate that our proposed model is applicable to a variety of images. Compared with state-of-the-art methods, our proposed method achieves better results on both synthetic and real-world images.
![net_architecture.png](https://qiita-image-store.s3.amazonaws.com/0/238733/4201579a-04cf-1ef2-86f6-4dd6d29a9c9d.png)
<img src="https://qiita-image-store.s3.amazonaws.com/0/238733/dc272717-b7e8-7e3b-a316-9b37daf15fdb.png" width="500">

## Citation

Please cite this paper if you use this code.

```
@INPROCEEDINGS{8451612, 
author={T. {Matsui} and T. {Fujisawa} and T. {Yamaguchi} and M. {Ikehara}}, 
booktitle={2018 25th IEEE International Conference on Image Processing (ICIP)}, 
title={Single-Image Rain Removal Using Residual Deep Learning}, 
year={2018}, 
volume={}, 
number={}, 
pages={3928-3932},
}
```



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

[takuro-matsui](http://tkhm.elec.keio.ac.jp/)

If you have any questions, please feel free to send us an e-mail matsui@tkhm.elec.keio.ac.jp.
