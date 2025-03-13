from functools import partial

import matplotlib.pyplot as plt
import networkx as nx
import numpy as np
from scipy.linalg import eig, expm
from scipy.io import savemat

def barabasi_albert(N=50, m=2, seed=None):
    rng = np.random.default_rng(seed)
    dg = nx.barabasi_albert_graph(N, m, seed=int(seed)).to_directed()
    # prune some edges at random*
    eidx = rng.choice(len(dg.edges), len(dg.edges) // 4, replace=False)
    edges = [e for i, e in enumerate(dg.edges) if i in eidx]
    for u, v in edges:
        # 1. keep at least one edge
        # 2. make sure each node is connected
        A = nx.adjacency_matrix(dg).todense()
        if A.sum(0)[v] != 1 and A.sum(1)[u] != 1:
            dg.remove_edge(u, v)
    return dg


def quasi_strongly_connected(f, seed):
    rng = np.random.default_rng(seed)
    while True:
        seed = rng.integers(1e8)
        g = f(seed=seed)

        A = nx.adjacency_matrix(g).todense()
        L = np.diag(A.sum(1)) - A
        lv, _, _ = eig(L, left=True)
        zero_eigval_cnt = np.isclose(0, lv.real, atol=1e-5).sum()
        if zero_eigval_cnt == 1:
            break
    return g


def main():
    g = quasi_strongly_connected(partial(barabasi_albert), 42)
    print(g)
    nx.draw(g, with_labels=True, font_color="white")
    plt.show()
    A = nx.adjacency_matrix(g).todense()
    L = np.diag(A.sum(1)) - A
    rho = np.ones((1, 50)) @ expm(-L*100000000)
    print(rho)

    print(A)

    savemat("ba_graph_matrix.mat", {"A": A})




if __name__ == "__main__":
    main()