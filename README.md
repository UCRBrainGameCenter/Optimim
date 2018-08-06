### Datasets

Old datasets: Tapback and Recall
New datasets: Recollect 2016 and 2017

### HMM

### To train the HMM:

Run train_hmm('recollect') to train the HMM on recollect

Run train_hmm('tapback') to train the HMM on recall

The follwing list of functions are called:
1. `setup_newDS()` loads the data for recollect 
2. `setup_oldDS()` loads the data for tapback
3. `compute_emission_prob()` returns the emission matrix _B_
4. `baum_welch_cont()` finds the transition matrix _A_ and the initial probabilities _Pi_ Parameters
5. `reestimate_A()` provides MLE for _A_ and _Pi_
6. `single_seq()` computes expected sufficient statistics for each training sequence
7. `alpha_beta_pass()` carries out the forward-backward procedure
8. `forward2()` computes the prediction
9. `compute_rmse()` computes the rmse and the predictions
	
### To test the HMM:

Run `test_hmm(A,Pi,accu,nbacks,nTrials)`, Values returned are: Test_Predicted_Values, Test_Actual_Values, test_rmse, test_B
	
### To obtain predicted n-level trajectory plots from HMM:

Run `explot3(A,Pi,test_B,test_n_backs_list,Test_Predicted_Values,Test_Actual_Values)`. The plots are saved into _'User_Skill_Trace.pdf'_

### To compare models:

`explot2()` generates plots that correspond to the mean and the variance of the error residuals across all subjects

### To tune global item-parameters (rho, c, d) for HMM:

Run `tuning_parameters()`. Does a grid-search. Adjust suitable ranges for each parameter if needed.
	
### To write matlab objects into csv files:

Run `write_file()`

### To Cluster the sequences via EM on the HMM:

1. Run `get_cluster_centers()`: Current number of clusters = 3, can be changed with more data
2. `pre_train()` : Initializing the cluster centers
3. `baum_welch_cont_EM()` : performs EM clustering
4. `reestimate_A_EM()`: Re-estimates cluster centers 
5. `assignCluster()`: Assigns a sequence to a cluster

### To analyze clusters:

Run `analysis_subj16()` and `analysis_subj16()` to analyze clusters formed in Recollect-2016 and Recollect-2017 respectively.

NOTE: The Tapback and Recall datasets test subjects that go upto a n-back of 9.
The memory score is 0.25, hence state space is 36, with 3 intermediate states between each level.

### UKF model

### To train the UKF model:

Run `UKFTrain('recollect')` to train the UKF model on recollect

Run `UKFTrain('tapback')` to train theUKF model on recall

The follwing list of functions are called:
1. `setup_newDS()` loads the data for recollect 
2. `setup_oldDS()` loads the data for tapback
3. `learn_kalman()` finds the parameters: _A_, _B_, _Q_, _R_ ,_X0_, _V0_ via EM
4. `Estep()` computes the expected sufficient statistics
5. `ukalman_filter()` computes filtered estimates
6. `rts_smoother()` computes smoothened estimates
7. `calc_sigmapoints()` computes the sigma points for the unscented transform.
8. `g()` is the non-linear function in the observation model
	
### To test the UKF model:

Run `compute_rmse()`, that computes the rmse and the predictions

### To obtain predicted n-level trajectory plots from the UKF model:

Run `explot3()`. The plots are saved into _'User_Skill_Trace.pdf'_

### To Cluster the sequences via EM on the UKF model:

NOTE: this doesn't converge. It can be tried with larger datasets.

Run `UKF_EM()` to cluster sequences. Current number of clusters = 2, can be changed with more data. It calls `learn_kalman_EM`.

