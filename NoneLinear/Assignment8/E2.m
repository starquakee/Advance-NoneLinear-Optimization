close all
function f = Ff(x)
    sum1 = sum((x - 1/sqrt(8)).^2);
    sum2 = sum((x + 1/sqrt(8)).^2);
    f(1) = 1 - exp(-sum1);
    f(2) = 1 - exp(-sum2);
end

function f = Ft(x)
    f(1) = 1 / x(1) * (1 + (x(2)^2 + x(3)^2)^0.25 * (sin(50 * (x(2)^2 + x(3)^2)^0.1)^2 + 1));
    f(2) = x(1);
end
Main(100, 0.7, 0.2, 10, 3, @() (rand - 0.5) * 0.3, 0.61, 0.81);

function [] = Main(N, pc, pm, sharing, mating, mutationFunc, pStop1, pStop2)
    rng default
    iter = ceil(500 / (N / 100));
    figure
    titleStr = sprintf('f_f: N = %d, p_c = %.1f, p_m = %.1f', N, pc, pm);
    MOEA(@Ff, -2 * ones(8, 1), 2 * ones(8, 1), pc, pm, sharing, mating, N, iter, 5, pStop1, mutationFunc, ...
         @(i, popF, eliteF) ParetoFrontPlot(sprintf('%s, gen = %s', titleStr, string(i)), [0, 1; 0, 1], popF, eliteF));
    figure
    titleStr = sprintf('f_t: N = %d, p_c = %.1f, p_m = %.1f', N, pc, pm);
    
    MOEA(@Ft, [0.5; -2; -2], [1; 2; 2], pc, pm, sharing, mating, N, iter, 5, pStop2, mutationFunc, ...
         @(i, popF, eliteF) ParetoFrontPlot(sprintf('%s, gen = %d', titleStr, i), [0, 2.5; 0, 1.2], popF, eliteF));
end


function [] = ParetoFrontPlot(titleStr, lims, popF, eliteF)
	clf
	hold on
	scatter(popF(:, 1), popF(:, 2), 'blue')
	scatter(eliteF(:, 1), eliteF(:, 2), 'red', 'filled')
	title(titleStr)
	xlabel("f_1")
	ylabel("f_2")
	xlim(lims(1, :))
	ylim(lims(2, :))
	drawnow
	hold off
end

function [Fs] = Fitness(f, population)
	s = size(population);
	Fs = splitapply(@(x){f(x)}, population, 1:s(2));
	Fs = cell2mat(Fs');
end

function [ranks] = Ranks(Fs1, Fs2, M)
	ranks = Fs1(:, 1)' ~= Fs2(:, 1);
	for i = 2 : M
		ranks = ranks | (Fs1(:, i)' ~= Fs2(:, i));
	end
	for i = 1 : M
		ranks = ranks & (Fs1(:, i)' >= Fs2(:, i));
	end
	ranks = sum(ranks, 1) + 1;
end

function [c] = DomininateCount(Fs1, Fs2, M)
	c = Fs1(:, 1)' <= Fs2(:, 1);
	for i = 2 : M
		c = c & (Fs1(:, i)' <= Fs2(:, i));
	end
	c = sum(c, 1);
end

function [sigma, sharedFs] = SharedFitness(Fs, ranks, N, M, alpha)
	Fmin = splitapply(@min, Fs, 1:M);
	ds = zeros(1, M);
	for i = 1 : M
		FminI = Fs(find(Fs(:, i) == Fmin(i), 1), :);
		ds(i) = norm(FminI - Fmin);
	end
	dmin = norm(ds);
	dmax = sum(ds);
	sigma = N ^ (-1 / (M - 1)) * (dmax + dmin) / 4;
	ds = zeros(N, N);
	for i = 1 : M
		ds = ds + (Fs(:, i) - Fs(:, i)') .^ 2;
	end
	ds = sqrt(ds);
	ds = min(ds, sigma);
	sharedFs = splitapply(@(x) sum(1 - (x ./ sigma) .^ alpha), ds, 1:N);
	sharedFs = 1 ./ ranks ./ sharedFs;
end

function [tempPop, Fs, ranks, sigma] = Selection(f, population, N, M, D, alpha)
	Fs = Fitness(f, population);
	ranks = Ranks(Fs, Fs, M);
	[sigma, sharedFs] = SharedFitness(Fs, ranks, N, M, alpha);
	tempPop = zeros(D, N);
	for i = 1 : 2 * N
		idx = randperm(N, 2);
		c1 = population(:, idx(1));
		c2 = population(:, idx(2));
		c1dom = ranks(idx(1)) == 1;
		c2dom = ranks(idx(2)) == 1;
		if c1dom == c2dom
			f1 = sharedFs(idx(1));
			f2 = sharedFs(idx(2));
			p = (f1 > f2) * c1 + (f1 <= f2) * c2;
		else
			p = c1dom * c1 + c2dom * c2;
		end
		tempPop(:, i) = p;
	end
end

function [outputs] = Crossover(f, population, Pc, sigma, N, M, D)
	Fs = Fitness(f, population);
	ds = zeros(N, N);
	for i = 1 : M
		ds = ds + (Fs(1:N, i)' - Fs(N+1:end, i)) .^ 2;
	end
	ds = sqrt(ds);
	outputs = zeros(D, N);
	for i = 1 : N
		cross = rand(1) < Pc;
		if cross
			inRange = find(ds(:, i) <= sigma);
			if isempty(inRange)
				mate = randi(N, 1) + N;
				r = randi(2) - 1;
			else
				mate = inRange(randi(length(inRange), 1)) + N;
				r = rand(1);
			end
			outputs(:, i) = r * population(:, i) + (1 - r) * population(:, mate);
		else
			outputs(:, i) = population(:, i);
		end
	end
end

function [population] = Mutation(mutationFunc, population, lb, ub, Pm, N, ~, D)
	for i = 1 : N
		if rand(1) < Pm
			idx = randi(D, 1);
			r = mutationFunc();
			population(idx, i) = population(idx, i) + r;
			population(idx, i) = max(min(population(idx, i), ub(idx)), lb(idx));
		end
	end
end

function [elite, eliteF] = ElitismUpdate(elite, eliteF, population, Fs, ranks, N, M, D, alpha)
	paretoFront = ranks == 1;
	population = population(:, paretoFront);
	Fs = Fs(paretoFront, :);
	rOld = Ranks(eliteF, Fs, M) == 1;
	rNew = Ranks(Fs, eliteF, M) == 1;
	elite = cat(2, elite(:, rOld), population(:, rNew));
	eliteF = cat(1, eliteF(rOld, :), Fs(rNew, :));
	elite = unique(cat(1, elite, eliteF')', 'rows', 'stable')';
	eliteF = elite(D+1:end, :)';
	elite = elite(1:D, :);
	sizeNow = length(eliteF(:, 1));
	if sizeNow > N / 2
		[~, sharedFs] = SharedFitness(eliteF, ones(1, sizeNow), sizeNow, M, alpha);
		sortedFs = sortrows([sharedFs; 1:sizeNow]', 'descend');
		idx = sortedFs(1:N/2, 2);
		idx = idx(end:-1:1);
		elite = elite(:, idx);
		eliteF = eliteF(idx, :);
	end
end

function [eliteF, elite] = MOEA(f, lb, ub, Pc, Pm, alpha, beta, N, maxIter, pLen, pStop, mutationFunc, callback)
	M = length(f(lb));
	D = length(lb);
	lb = lb(:); ub = ub(:);
	newPop = rand(D, N) .* repmat(ub - lb, [1, N]) + repmat(lb, [1, N]);
	Fs = 1e5 * ones(N, M);
	elite = newPop(:, 1);
	eliteF = f(elite);
	ps = ones(1, pLen);
	for i = 1 : maxIter
		FsOld = Fs;
		population = newPop;
		[newPop, Fs, ranks, sigma] = Selection(f, population, N, M, D, alpha);
		[elite, eliteF] = ElitismUpdate(elite, eliteF, population, Fs, ranks, N, M, D, alpha);
		callback(i, Fs, eliteF);
		p = sum(DomininateCount(Fs(ranks == 1, :), FsOld, M) > 0) / sum(ranks == 1);
		ps = [ps(2:end), p];
		if mean(ps) < pStop
			break;
		end
		newPop = Crossover(f, newPop, Pc, sigma * beta, N, M, D);
		newPop = Mutation(mutationFunc, newPop, lb, ub, Pm, N, M, D);
	end
end
