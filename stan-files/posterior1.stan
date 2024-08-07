data {
    int<lower=1> N; 
    array[N] int<lower=0> age;
    array[N] int<lower=0> bps;
    array[N] int<lower=0> thalach;
    array[N] int<lower=0, upper=1> y;
}

parameters {
    real alpha;
    real beta1;
    real beta2;
    real beta3;
}

transformed parameters {
    array[N] real combined_linear_predictor;
    for (n in 1:N) {
        combined_linear_predictor[n] = alpha + beta1 * age[n] + beta2 * bps[n] + beta3 * thalach[n];
    }
}

model {
    alpha ~ normal(-1.75, 0.75);
    beta1 ~ normal(0.0083, 0.00332);
    beta2 ~ normal(0.00357, 0.001428);
    beta3 ~ normal(0.00385, 0.00154);

    y ~ bernoulli_logit(combined_linear_predictor);
}

generated quantities {
    array[N] real<lower=0, upper=1> combined_heart_disease_prob;
    array[N] real log_lik;

    for (n in 1:N) {
        combined_heart_disease_prob[n] = inv_logit(combined_linear_predictor[n]);
        log_lik[n] = bernoulli_logit_lpmf(y[n] | combined_linear_predictor[n]);
    }
}