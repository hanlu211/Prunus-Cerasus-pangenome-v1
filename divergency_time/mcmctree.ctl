          seed = -1 *设置随机数作为seed，-1代表使用系统当前时间作为随机数
       seqfile = input.phy *输入多序列比对文件
      treefile = input.tree *带校准点（化石时间）的有根树文件
       outfile = mcmc.out *输出文件
      mcmcfile = mcmc.txt *输出的mcmc信息文件，可用Tracer软件查看

       seqtype = 0  * 设置多序列比对数据类型；0：核酸数据；1：密码子比对数据；2：氨基酸数据；
	   usedata = 3
     * 是否利用多序列比对数据；
	   * 0: no data不使用，不会进行likelihood估算，会快速得到mcmc树，但分歧时间不可用; 
	   * 1:seq like，使用多序列比对数据进行likelihood估算，正常进行mcmc; usedata=1时model无法选择；
	   * 2:normal 进行正常的approximation likelihood分析，不读取多序列比对数据，直接读取当前目录的in.BV文件，in.BV是由usedata = 3时生成的out.BV重命名得来；此外，由于程序BUG，当设置usedata = 2时，一定要在改行参数后加 *，否则程序报错 Error: file name empty..；
	   * 3：程序利用多序列比对数据调用baseml/codeml命令对数据进行分析，生成out.BV文件。由于mcmctree调用baseml/codeml进行估算的参数设置可能不太好（特别时对蛋白序列进行估算时），推荐自己修改软件自动生成的baseml/codeml配置文件，然后再手动运行baseml/codeml命令，再整合其结果文件为out.BV文件。

		 ndata = 1    * 输入的多序列比对的数据区域的数量；
         clock = 2    * 设置分子钟算法，1: global clock，表示所有分支进化速率一致; 2: independent rates，各分支的进化速率独立且进化速率的对数log(r)符合正态分布; 3，correlated rates方法，和方法2类似，但是log(r)的方差和时间t相关。
*       TipDate = 1 100  *当外部节点由取样时间时使用该参数进行设置，同时该参数也设置了时间单位。具体数据示例请见examples/TipData文件夹。
        RootAge = '<115'  * constraint on root age, used if no fossil for root.设置root节点的分歧时间，一般设置一个最大值。

         model = 7    * models for DNA:
                        * 0:JC69, 1:K80, 2:F81, 3:F84, 4:HKY85；*设置碱基替换模型；当设置usedata = 1时，model不能使用超过4的模型，所以usedata = 1时用model = 4；usedata不等于1时，用model = 7，即GTR模型；
                      * models for codons:
                        * 0:one 恒定速率模型, 1:b 中性模型, 2:2 or more dN/dS ratios for branches 选择模型。
                      * models for AAs or codon-translated AAs:
                        * 0:poisson, 1:proportional, 2:Empirical, 3:Empirical+F
                        * 6:FromCodon, 7:AAClasses, 8:REVaa_0, 9:REVaa(nr=189)
         alpha = 0.5   * alpha for gamma rates at sites；*核酸序列中不同位点，其进化速率不一致，其变异速率服从GAMMA分布。一般设置GAMMA分布的alpha值为0.5。若该参数值设置为0，则表示所有位点的进化速率一致。此外，当userdata = 2时，alpha、ncatG、alpha_gamma、kappa_gamma这4个GAMMA参数无效。因为userdata = 2时，不会利用到多序列比对的数据。
         ncatG = 5    * No. categories in discrete gamma；设置离散型GAMMA分布的categories值。

     cleandata = 0    * remove sites with ambiguity data (1:yes, 0:no)?

       BDparas = 1 1 0.1   * birth, death, sampling；*设置出生率、死亡率和取样比例。若输入有根树文件中的时间单位发生改变，则需要相应修改出生率和死亡率的值。例如，时间单位由100Myr变换为1Myr，则要设置成".01 .01 0.1"。
   kappa_gamma = 6 2      * gamma prior for kappa；设置kappa（转换/颠换比率）的GAMMA分布参数。
   alpha_gamma = 1 1      * gamma prior for alpha；设置GAMMA形状参数alpha的GAMMA分布参数。

   rgene_gamma = 2 20 1   * gamma prior for rate for genes；设置序列中所所有位点平均[碱基/密码子/氨基酸]替换率的Dirichlet-GAMMA分布参数：alpha=2、beta=20、初始平均替换率为每100million年（取决于输入有根树文件中的时间单位）1个替换。若时间单位由100Myr变换为1Myr，则要设置成"2 2000 1"。总体上的平均进化速率为：2 / 20 = 0.1 个替换 / 每100Myr，即每个位点每年的替换数为 1e-9。
  sigma2_gamma = 1 10 1    * gamma prior for sigma^2     (for clock=2 or 3)；设置所有位点进化速率取对数后方差（sigma的平方）的Dirichlet-GAMMA分布参数：alpha=1、beta=10、初始方差值为1。当clock参数值为1时，表示使用全局的进化速率，各分枝的进化速率没有差异，即方差为0，该参数无效；当clock参数值为2时，若修改了时间单位，该参数值不需要改变；当clock参数值为3时，若修改了时间单位，该参数值需要改变。

      finetune = 1: .1 .1 .1 .1 .1 .1  * times, rates, mixing, paras, RateParas；冒号前的值设置是否自动进行finetune，一般设置成1，然程序自动进行优化分析；冒号后面设置各个参数的步进值：times, musigma2, rates, mixing, paras, FossilErr。由于有了自动设置，该参数不像以前版本那么重要了，可能以后会取消该参数。

         print = 1  *设置打印mcmc的取样信息：0，不打印mcmc结果；1，打印除了分支进化速率的其它信息（各内部节点分歧时间、平均进化速率、sigma2值）；2，打印所有信息。 
        burnin = 1000000  *将前1000000次迭代burnin后，再进行取样（即打印出该次迭代估算的结果信息，各内部节点分歧时间、平均进化速率、sigma2值和各分支进化速率等）。
      sampfreq = 10  *每10次迭代则取样一次
       nsample = 500000  *当取样次数达到该次数时，则取样结束，同时结束程序。

*** Note: Make your window wider (100 columns) when running this program.
