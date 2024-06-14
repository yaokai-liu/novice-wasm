function abs32(_num: number): number {
    return _num >= 0 ? _num : - _num;
}

function abs64(_num: bigint): bigint {
    return _num >= 0n ? _num : - _num;
}

export { abs32, abs64 };
