function center_action = compute_center_action(z, dim, box_i, k, interval_number, M)
    % M is the number of splits
    left = z(box_i, k) - dim(box_i, k) / 2;
    center_action = left + dim(box_i, k) / M / 2 + (interval_number - 1) * dim(box_i, k) / M;
end

