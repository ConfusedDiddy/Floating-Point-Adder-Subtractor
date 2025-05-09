import struct

def binary32_to_float(binary_str):
    """Converts 32-bit binary string to float."""
    if len(binary_str) != 32:
        raise ValueError("Input must be 32-bit binary string")
    byte_value = int(binary_str, 2).to_bytes(4, byteorder='big')
    return struct.unpack('!f', byte_value)[0]

def decompose_float(x):
    """Decomposes float into sign, exponent, and significand."""
    packed = struct.pack('!f', x)
    bits = int.from_bytes(packed, byteorder='big')
    sign = (bits >> 31) & 1
    exponent = (bits >> 23) & 0xFF
    significand = bits & 0x7FFFFF
    
    if exponent == 0:
        return (sign, -126, significand) if significand != 0 else (sign, 0, 0)
    else:
        return (sign, exponent - 127, (1 << 23) | significand)

def float_add_sub(a, b, op):
    """Floating-point adder/subtractor with full sign handling and step outputs."""
    # Stage 1: Unpack with sign bits
    s1, e1, m1 = decompose_float(a)
    s2_orig, e2_orig, m2_orig = decompose_float(b)
    
    print("\n=== Stage 1: Unpack ===")
    print(f"A: sign={s1}, exponent={e1}, significand={bin(m1)[2:].zfill(24)}")
    print(f"B: sign={s2_orig}, exponent={e2_orig}, significand={bin(m2_orig)[2:].zfill(24)}")

    # Stage 2: Control & Sign Logic
    s2 = s2_orig
    if op == 'sub':
        s2 = 1 - s2_orig
    
    print("\n=== Stage 2: Control & Sign Logic ===")
    print(f"Operation: {op.upper()} → B's new sign: {s2}")

    # Stage 3: Swap Logic
    swap = 0
    a_larger = False
    if e1 > e2_orig or (e1 == e2_orig and m1 > m2_orig):
        a_larger = True
    elif e1 == e2_orig and m1 == m2_orig and s1 != s2:
        print("\nEqual magnitude with opposite signs → result 0.0")
        return 0.0
    
    if not a_larger:
        swap = 1
        s1, s2 = s2, s1
        e1, e2_orig = e2_orig, e1
        m1, m2_orig = m2_orig, m1
        print(f"\nSwapped operands: New A (sign={s1}), New B (sign={s2})")

    # Determine effective operation
    effective_op = 'add' if s1 == s2 else 'sub'
    result_sign = s1 if (effective_op == 'add') or (m1 >= m2_orig) else s2
    
    print(f"\nControl Signals:")
    print(f"  Effective operation: {effective_op.upper()}")
    print(f"  Result sign: {result_sign}")

    # Stage 4: Alignment
    print("\n=== Stage 3: Alignment ===")
    e_diff = e1 - e2_orig
    guard, round_bit, sticky = 0, 0, 0
    
    if e_diff > 0:
        shift = e_diff
        mask = (1 << shift) - 1
        shifted_out = m2_orig & mask
        m2_aligned = m2_orig >> shift
        
        # Capture guard bits
        if shift >= 1:
            guard = (shifted_out >> (shift-1)) & 1
        if shift >= 2:
            round_bit = (shifted_out >> (shift-2)) & 1
        if shift >= 3:
            sticky = 1 if (shifted_out & ((1 << (shift-2)) -1)) else 0
        
        print(f"Aligning B by shifting right {shift} bits:")
        print(f"  Original: {bin(m2_orig)[2:].zfill(24)}")
        print(f"  Aligned:  {bin(m2_aligned)[2:].zfill(24)}")
        print(f"  Lost bits: {bin(shifted_out)[2:].zfill(shift)}")
        print(f"  Guard: {guard}, Round: {round_bit}, Sticky: {sticky}")
    else:
        m2_aligned = m2_orig
        print("No alignment needed")

    # Stage 5: Add/Sub
    print("\n=== Stage 4: Add/Subtract ===")
    if effective_op == 'add':
        sum_m = m1 + m2_aligned
        print(f"Adding magnitudes:")
    else:
        sum_m = m1 - m2_aligned
        print(f"Subtracting magnitudes:")
        if sum_m < 0:
            sum_m = -sum_m
            result_sign = 1 - result_sign
            print(f"Negative intermediate → sign flipped to {result_sign}")

    print(f"  A: {bin(m1)[2:].zfill(24)}")
    print(f"  B: {bin(m2_aligned)[2:].zfill(24)}")
    print(f"  Raw sum: {bin(sum_m)[2:].zfill(24)} (Decimal: {sum_m})")

    # Stage 6: Normalization
    print("\n=== Stage 5: Normalization ===")
    original_exp = e1
    
    # Handle overflow (add case)
    if sum_m >= (1 << 24):
        print(f"Overflow detected (bit length: {sum_m.bit_length()})")
        sticky |= sum_m & 1
        sum_m >>= 1
        e1 += 1
        print(f"Right shift 1 → {bin(sum_m)[2:].zfill(24)}")
        print(f"New exponent: {e1}")

    # Handle leading zeros (sub case)
    leading_zeros = 24 - sum_m.bit_length()
    if leading_zeros > 0 and sum_m != 0:
        print(f"Leading zeros detected: {leading_zeros}")
        sum_m <<= leading_zeros
        e1 -= leading_zeros
        print(f"Left shift {leading_zeros} → {bin(sum_m)[2:].zfill(24)}")
        print(f"New exponent: {e1}")

    # Stage 7: Rounding
    print("\n=== Stage 6: Rounding ===")
    print(f"Pre-rounding: {bin(sum_m)[2:].zfill(24)}")
    print(f"Guard bits: G={guard}, R={round_bit}, S={sticky}")
    
    lsb = sum_m & 1
    round_up = False
    
    if guard:
        if (round_bit | sticky):
            round_up = True
        else:  # Tie case
            round_up = (lsb == 1)

    if round_up:
        sum_m += 1
        print(f"Rounding applied → {bin(sum_m)[2:].zfill(24)}")

    # Post-rounding normalization
    print("\n=== Stage 7: Post-Rounding Normalization ===")
    if sum_m >= (1 << 24):
        print("Overflow after rounding")
        sum_m >>= 1
        e1 += 1
        print(f"Right shift 1 → {bin(sum_m)[2:].zfill(24)}")
        print(f"New exponent: {e1}")

    # Final packing
    print("\n=== Final Result ===")
    significand = sum_m & 0x7FFFFF
    stored_exp = e1 + 127
    
    if stored_exp >= 255:
        result = float('inf') if result_sign == 0 else float('-inf')
    elif stored_exp < 0:
        result = 0.0
    else:
        packed = (result_sign << 31) | (stored_exp << 23) | significand
        result = struct.unpack('!f', packed.to_bytes(4, 'big'))[0]

    print(f"Sign: {result_sign}")
    print(f"Exponent: {e1} → stored {stored_exp} ({bin(stored_exp)[2:].zfill(8)})")
    print(f"Significand: {bin(significand)[2:].zfill(23)}")
    return result

# User interface
print("IEEE-754 Floating Point Adder/Subtractor")
print("=======================================")
a_bin = input("Enter first operand (32-bit binary): ").strip()
b_bin = input("Enter second operand (32-bit binary): ").strip()
op = input("Operation (add/sub): ").strip().lower()

a = binary32_to_float(a_bin)
b = binary32_to_float(b_bin)
print("\nStarting computation...")
result = float_add_sub(a, b, op)

print("\n=== Final Result ===")
print(f"Decimal: {result}")
print(f"Hex: {struct.pack('!f', result).hex()}")
packed_result = struct.pack('!f', result)
binary_str = bin(int.from_bytes(packed_result, byteorder='big'))[2:].zfill(32)
print(f"Binary: {binary_str}")