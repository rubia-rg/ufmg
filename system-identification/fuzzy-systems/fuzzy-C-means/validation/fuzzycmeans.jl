######################################
# Author: Rúbia Reis Guerra
# git @rubia-rg
# Comparing Fuzzy-C-Means to K-Means
######################################
using MAT
using StatPlots
using Images
using Statistics
using LinearAlgebra
using Distances

### Finds distances between an observation and each cluster
function clustdist(X, c)
	n_obs, n_dim  = size(X)
	n_clust = size(c, 1)
	d = zeros(n_obs, n_clust)
	for i = 1:n_clust
		d[:, i] = colwise(Euclidean(), X', c[i, :])
	end
	return d
end

######################################
### FCM methods
### Updates FCM centroids based on the membership matrix
function fcmcentroid(X, U)
	n_obs, n_dim  = size(X)
	n_clust = size(U,2)
	c = zeros(n_clust, n_dim)
	for i = 1:n_clust
		c[i, :] = sum(((U[:, i].^2)'*X), dims=1)/sum((U[:, i]).^2)
	end
	return c
end

### Updates FCM membership matrix based on new centroids
function fcmmembership(X, c)
	n_obs, n_dim = size(X)
	n_clust = size(c, 1)
	U = zeros(n_obs, n_clust)
	d = clustdist(X, c)
	for i = 1:k
		U[:, i] = 1 ./sum(((d[:, i]./d[:, :]).^2), dims=2)
	end
	return U
end

######################################
### kmeans methods
### Updates kmeans centroids
function kmcentroid(X, U)
	n_obs, n_dim  = size(X)
	n_clust = size(U,2)
	c = zeros(n_clust, n_dim)
	for i = 1:n_clust
		c[i, :] = Statistics.mean((x_data .* U[:,i]), dims=1)
	end
	return c
end

### Updates kmeans membership matrix based on new centroids
function kmmembership(X, c)
	n_obs, n_dim = size(X)
	n_clust = size(c, 1)
	U = zeros(n_obs, n_clust)
	d = clustdist(X, c)
	U[findmin(d, dims=2)[2]] .= 1
	return U
end

######################################
### Experimental setup
### Static parameters
const N = 150
const k = 4
const tol = 0.3
const tol_iter = 10
const max_iter = 1000

### Importing dataset
global x_data = matread("fcm_dataset.mat")["x"]
global n_obs, n_dim = size(x_data)

### Initializing FCM results
global fcm_convergence = zeros(0)
global fcm_goodclust = zeros(0)
global fcm_cost = zeros(0)
global fcm_best_cent = zeros(0)
global fcm_best_clust = zeros(0)
global fcm_clusters = zeros(n_obs)

### Initializing kmeans results
global km_convergence = zeros(0)
global km_goodclust = zeros(0)
global km_cost = zeros(0)

### Colors for plotting
global cols = ["red", "blue", "green", "yellow"]

for n = 1:N
	### Initializing centroids
	global cent_init = rand(k, n_dim).*maximum(x_data)

	let ### FCM evaluation
		fcm_cent = cent_init
		fcm_U = fcmmembership(x_data, fcm_cent)
		fcm_J = zeros(0)
		fcm_unchanged = 0
		fcm_adequate = 0
		fcm_i = 0

		while(fcm_i < max_iter && fcm_unchanged < tol_iter)
			### Evaluate cost function,
			### new centroids and new membership matrix
			append!(fcm_J, sum((fcm_U.^2) .* clustdist(x_data, fcm_cent)))
			fcm_cent_old = fcm_cent
			fcm_U_old = fcm_U
			fcm_cent = fcmcentroid(x_data, fcm_U)
			fcm_U = fcmmembership(x_data, fcm_cent)

			### Count number of times clusters remain unchanged
			if(isequal(argmax(fcm_U, dims =2), argmax(fcm_U_old, dims =2)))
				fcm_unchanged += 1
			else
				fcm_unchanged = 0
			end

			### Count number of times good centroids are found
			if(!isempty(fcm_cost) && fcm_i > 0)
				# Check if new centroids are good enough
				if(fcm_J[fcm_i] <= (findmin(fcm_cost)[1]+tol))
					fcm_adequate += 1
				end

				### If new cost is the minimum so far,
				### save centroids and clusters
				if(fcm_J[fcm_i] < findmin(fcm_cost)[1])
					global fcm_best_cent = fcm_cent
					global fcm_best_clust = argmax(fcm_U, dims=2)
				end
			end
			fcm_i += 1
		end ### end FCM while loop

		### Save FCM results
		append!(fcm_convergence, fcm_i)
		append!(fcm_goodclust, fcm_adequate)
		append!(fcm_cost, fcm_J)

		### Save cost x Iterations plot
		if(n == 1)
			global fcm_plt = plot(collect(1:fcm_i), fcm_J, title="FCM: Cost", label="",
			xlabel="Iterations until convergence", ylabel="J",xlim=(0,40))
		else
			plot!(fcm_plt, collect(1:fcm_i), fcm_J, title="FCM: Cost", label="",
			xlabel="Iterations until convergence", ylabel="J",xlim=(0,40))
		end
		savefig(fcm_plt, "fcm_cost.png")

	end ### end FCM evaluation

	###############################

	let ### KM evaluation
		km_cent = cent_init
		km_U = kmmembership(x_data, km_cent)
		km_J = zeros(0)
		km_J_aux = zeros(0)
		km_unchanged = 0
		km_adequate = 0
		km_i = 0

		while(km_i < max_iter && km_unchanged < tol_iter)
			### Evaluate cost function,
			### new centroids and new membership matrix
			km_J_aux = (km_U .* clustdist(x_data, km_cent)) ./ sum(km_U, dims=1)
			km_J_aux[isnan.(km_J_aux)] .= 0
			append!(km_J, sum(km_J_aux))
			km_cent_old = km_cent
			km_U_old = km_U
			km_cent = kmcentroid(x_data, km_U)
			km_U = kmmembership(x_data, km_cent)

			### kmeans: Count number of times clusters remain unchanged
			if(isequal(argmax(km_U, dims=2), argmax(km_U_old, dims=2)))
				km_unchanged += 1
			else
				km_unchanged = 0
			end

			### kmeans: Count number of times good centroids are found
			if(!isempty(km_cost) && km_i > 0 && n > 1)
				# Check if new centroids are good enough
				if(km_J[km_i]*100 <= (findmin(km_cost)[1]*100+tol))
					km_adequate += 1
				end
			end
			km_i += 1
		end ### end while loop

		### Save kmeans results
		append!(km_convergence, km_i)
		append!(km_goodclust, km_adequate)
		append!(km_cost, km_J)

		### kmeans: Save cost x iterations plot
		if(n == 1)
			global km_plt = plot(collect(1:km_i), km_J.*100, title="kmeans: Cost", label="",
			xlabel="Iterations until convergence", ylabel="J",xlim=(0,40))
		else
			plot!(km_plt, collect(1:km_i), km_J.*100, title="kmeans: Cost", label="",
			xlabel="Iterations until convergence", ylabel="J",xlim=(0,40))
		end
		savefig(km_plt, "km_cost.png")
	end ### end kmeans evaluation

end ### end all evaluations

### Extract cluster indices
for i = 1:n_obs
	fcm_clusters[i] = fcm_best_clust[i][2]
end
fcm_clusters = round.(Int, fcm_clusters)

### Plot FCM clustering results
fcm_points = scatter(x_data[:,1], x_data[:,2], color=cols[fcm_clusters],
	title="FCM: cluster distribution", label="", legend=:bottomright)
fcm_points = scatter!(fcm_best_cent[:,1], fcm_best_cent[:,2], markercolor=:orange,
	markershape=:star5, markersize=:7, label="centroid", legend=:bottomright)
savefig(fcm_points, "fcm_points")

### Plot comparison results
method_names = ["FCM" "kmeans"]
convergence = boxplot(method_names, [fcm_convergence[2:end] km_convergence[2:end]],
	label=method_names, fillalpha=0.8, legend=:best, title="Iterations until convergence")
savefig(convergence, "convergence")
adequate_clust = boxplot(method_names, [fcm_goodclust[2:end] km_goodclust[2:end]],
	label=method_names, fillalpha=0.8, legend=:best)
savefig(adequate_clust, "adequate_clust")
