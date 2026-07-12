import os
import cooler
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import LogNorm

# ================= 1. 数据加载与参数设置 =================
cool_file = 'diploid_150K.cool'

if not os.path.exists(cool_file):
    raise FileNotFoundError(f"找不到转换后的矩阵文件 '{cool_file}'，请先运行: hic2cool convert -r 100000 inter_30.hic {cool_file}")

clr = cooler.Cooler(cool_file)

all_chroms = clr.chromnames
chroms_A = [c for c in all_chroms if 'CanChrA' in c]
chroms_B = [c for c in all_chroms if 'CanChrB' in c]

bins_df = clr.bins()[:]

has_weight = 'weight' in bins_df.columns
if has_weight:
    print("检测到平衡权重，将采用矩阵平衡校正 (balance=True) 进行绘图...")
else:
    print("未检测到 'weight' 列，将直接采用原始计数 (balance=False) 进行绘图...")

# ================= 2. 矩阵切分与坐标计算函数 =================
def get_haplotype_data(chrom_list):
    """根据染色体列表截取子矩阵并计算坐标轴刻度及边界"""
    # 筛选出属于当前单倍型的 bins 范围
    hap_bins = bins_df[bins_df['chrom'].isin(chrom_list)]
    start_idx, end_idx = hap_bins.index.min(), hap_bins.index.max() + 1
    
    # 提取矩阵。根据是否拥有权重来决定是否进行平衡校正
    mat = clr.matrix(balance=has_weight, sparse=False)[start_idx:end_idx, start_idx:end_idx]
    mat = np.nan_to_num(mat, nan=0.0) # 将校正后可能产生的 NaN 替换为 0
    
    ticks, labels, boundaries = [], [], []
    current_offset = 0
    
    for chrom in chrom_list:
        chr_len = len(hap_bins[hap_bins['chrom'] == chrom])
        # 染色体标签显示在当前区间的中心位置
        ticks.append(current_offset + chr_len / 2)
        
        # 格式化染色体名字显示 (例如 CanChrA1 -> Chr01)
        num_str = chrom.replace('CanChrA', '').replace('CanChrB', '')
        labels.append(f"Chr{int(num_str):02d}")
        
        current_offset += chr_len
        boundaries.append(current_offset) # 记录染色体边界分隔线位置
        
    return mat, ticks, labels, boundaries

mat_A, ticks_A, labels_A, bounds_A = get_haplotype_data(chroms_A)

mat_B, ticks_B, labels_B, bounds_B = get_haplotype_data(chroms_B)

# ================= 3. 使用 Matplotlib 绘制双侧热图 =================
fig, axes = plt.subplots(1, 2, figsize=(16, 7), constrained_layout=True)
fig.suptitle('Celastrus angulatus\nGenome-wide all-by-all Hi-C interaction (Resolution = 150 Kb)', fontsize=16, fontstyle='italic')

cmap = 'viridis' 

if has_weight:
    norm = LogNorm(vmin=0.005, vmax=5)
else:
    norm = LogNorm(vmin=1, vmax=500)

def plot_heatmap(ax, mat, ticks, labels, boundaries, title):
    """单侧热图渲染子函数"""
    im = ax.imshow(mat, cmap=cmap, norm=norm, origin='upper', interpolation='none')
    ax.set_title(title, fontsize=14, pad=10)
    
    for b in boundaries[:-1]:
        ax.axhline(b, color='white', linewidth=0.4, alpha=0.7)
        ax.axvline(b, color='white', linewidth=0.4, alpha=0.7)
        
    ax.set_xticks(ticks)
    ax.set_xticklabels(labels, rotation=90, fontsize=8)
    ax.set_yticks(ticks)
    ax.set_yticklabels(labels, fontsize=8)
    
    ax.tick_params(axis='both', which='both', length=0)
    return im

im_A = plot_heatmap(axes[0], mat_A, ticks_A, labels_A, bounds_A, 'Haplotype A')
im_B = plot_heatmap(axes[1], mat_B, ticks_B, labels_B, bounds_B, 'Haplotype B')

# ================= 4. 添加高规格 Colorbar 并保存 =================
cbar = fig.colorbar(im_B, ax=axes, shrink=0.6, pad=0.02)
cbar.ax.tick_params(labelsize=10)

cbar.set_label(label='Log$_{10}$ Interaction Frequency', size=12, labelpad=10)

output_pdf = 'HiC_Heatmap.pdf'
output_png = 'HiC_Heatmap.png'

plt.savefig(output_pdf, dpi=300, bbox_inches='tight')
plt.savefig(output_png, dpi=300, bbox_inches='tight')
