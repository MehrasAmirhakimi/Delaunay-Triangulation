% DT2 test part 2

    ins = nodes(fins(i), :);
    edges = insertion(ins, edges, triangles);
    nodes(ins(1), 5) = 1;
    triangles = trigen2(edges, nodes);
