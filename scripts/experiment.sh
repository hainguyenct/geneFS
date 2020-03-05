: '
Author: Tinh Dao dcongtinh@gmail.com
Original gene family data is filtered by feature selection (Perceptron Weight Based Filter) and after that is generating images (gray/color image) from the new set of selected features before fetching into a learning architecture like Linear Regression (FC) or CNN2D
'

dataset=('cirgene' 'colgene' 'ibdgene' 'obegene' 't2dgene' 'wt2dgene') # Gene family datasets

: '
Configure PATH
'
ROOT='/Users/dcongtinh'
path_data=$ROOT'/Downloads/data/'                                  # For my macbook
machine_path=$ROOT'/gene-abundance'                                # For my macbook
file_run=$ROOT'/gene-abundance/subdeepmg/__main__.py'              # Use package deepmg
file_read_results=$ROOT'/gene-abundance/subdeepmg/read_results.py' # Use package deepmg
algo_redu='pwbf'                                                   # Perceptron Weight Based Filter
new_dim=576                                                        # Image 32x32 pixels
run_time=10
num_bin=10
type_bin='eqf'
scale_mode='qtf'
models=('fc_model' 'model_cnn')
colormaps=('gray' 'rainbow')
type_emb='fills'

start=$(date +%s)
for model_v in "${models[@]}"; do
    for colormap in "${colormaps[@]}"; do
        for dataset_name in "${dataset[@]}"; do
            res_folder=$machine_path'/experiment/results/'$model_v'/'$scale_mode'_'$algo_redu$new_dim'_10_'$type_emb$type_bin'_nb'$num_bin'_auy_'$colormap'/' # Results folder
            img_folder=$machine_path'/experiment/images/'$model_v'/'$scale_mode'_'$algo_redu$new_dim'_10_'$type_emb$type_bin'_nb'$num_bin'_auy_'$colormap'/'  # Images folder

            if [[ $colormap -eq 'gray' ]]; then
                python3 $file_run --save_para y --original_data_folder $path_data --data_name $dataset_name --run_time $run_time --algo_redu $algo_redu --new_dim $new_dim --model $model_v --auto_v y --parent_folder_results $res_folder --parent_folder_img $img_folder --scale_mode $scale_mode --type_bin $type_bin --num_bin $num_bin --type_emb $type_emb -z 255 --colormap $colormap --channel 1
            else
                python3 $file_run --save_para y --original_data_folder $path_data --data_name $dataset_name --run_time $run_time --algo_redu $algo_redu --new_dim $new_dim --model $model_v --auto_v y --parent_folder_results $res_folder --parent_folder_img $img_folder --scale_mode $scale_mode --type_bin $type_bin --num_bin $num_bin --type_emb $type_emb -z 255 --colormap $colormap --channel 3 --preprocess_img vgg16
            fi
            python3 $file_read_results -i $res_folder -o $res_folder
        done
    done
done
end=$(date +%s)

echo "Total runtime: "$((end - start))" seconds."
say "Your experiment has finished. Please collect your results!" # for macos
