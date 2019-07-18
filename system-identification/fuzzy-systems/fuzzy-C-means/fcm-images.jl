######################################
# Author: Rúbia Reis Guerra
# git @rubia-rg
# Comparing Fuzzy-C-Means to K-Means
######################################
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

### Updates FCM membership matrix based on new centroids
function numcluster(imgnum)
	if(imgnum in [1 2 3 5])
		return 8
	elseif(imgnum in [4 6 7 8])
		return 16
	else
		return 20
	end
end

######################################
### Experimental setup
### Static parameters
const N = 11
const tol_iter = 10
const max_iter = 1000
global n_photo = 0

for n = 1:N
	n_photo += 1
	global k = numcluster(n_photo)

	if(n < 10)
		img_path = "./ImagensTeste/photo00" * string(n) * ".jpg"
	elseif(n == 11)
		img_path = "./ImagensTeste/photo0" * string(n) * ".png"
	else
		img_path = "./ImagensTeste/photo0" * string(n) * ".jpg"
	end

	img = restrict(load(img_path))
	cv = channelview(img)
	rv = rawview(cv)

	r = rv[1,:,:]
	g = rv[2,:,:]
	b = rv[3,:,:]

	n_rows, n_cols = size(r)
	img_array = [r[:] g[:] b[:]]

	n_obs, n_dim = size(img_array)

	global fcm_cent = rand(k, n_dim).*maximum(img_array)
	global fcm_U = fcmmembership(img_array, fcm_cent)
	global fcm_J = zeros(0)
	global fcm_best_cent = zeros(0)
	global fcm_best_clust = zeros(0)
	global fcm_unchanged = 0
	global fcm_i = 0

	while(fcm_i < max_iter && fcm_unchanged < tol_iter)
		### Evaluate cost function,
		### new centroids and new membership matrix
		append!(fcm_J, sum((fcm_U.^2) .* clustdist(img_array, fcm_cent)))
		fcm_cent_old = fcm_cent
		fcm_U_old = fcm_U
		fcm_cent = fcmcentroid(img_array, fcm_U)
		fcm_U = fcmmembership(img_array, fcm_cent)

		### Count number of times clusters remain unchanged
		if(isequal(argmax(fcm_U, dims=2), argmax(fcm_U_old, dims=2)))
			fcm_unchanged += 1
		else
			fcm_unchanged = 0
		end

		### Count number of times good centroids are found
		if(fcm_i > 0)
			### If new cost is the minimum so far,
			### save centroids and clusters
			if(fcm_J[fcm_i] <= findmin(fcm_J)[1])
				global fcm_best_cent = fcm_cent
				global fcm_best_clust = argmax(fcm_U, dims=2)
			end
		end
		fcm_i += 1
	end ### end FCM while loop

	fcm_clusters = zeros(n_obs)

	for j = 1:n_obs
		fcm_clusters[j] = fcm_best_clust[j][2]
	end

	fcm_clusters = round.(Int, fcm_clusters)

	for i = 1:n_obs
		img_array[i,:] = fcm_best_cent[fcm_clusters[i],:]
	end

	r_new = reshape(img_array[:,1], n_rows, n_cols)
	g_new = reshape(img_array[:,2], n_rows, n_cols)
	b_new = reshape(img_array[:,3], n_rows, n_cols)

	img_new = colorview(RGB, r_new, g_new, b_new)
	save(string(n)*".png",img_new)
end
