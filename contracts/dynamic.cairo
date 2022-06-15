
# # SPDX-License-Identifier: AGPL-3.0-or-later

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_block_timestamp
from starkware.cairo.common.math_cmp import is_le

@contract_interface
namespace contract_B:
    func increase_balance(number : felt):
    end

    func get_balance() -> (number : felt):
    end
end

#############################################
# #                 STORAGE                 ##
#############################################

@storage_var
func __counter() -> (counter : felt):
end

@storage_var
func __lastExecuted() -> (lastExecuted : felt):
end

#############################################
# #                 GETTERS                 ##
#############################################

@view
func counter{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    counter : felt
):
    let (counter) = __counter.read()
    return (counter)
end

@view
func lastExecuted{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    lastExecuted : felt
):
    let (lastExecuted) = __lastExecuted.read()
    return (lastExecuted)
end

#############################################
# #                  TASK                   ##
#############################################

@view
func probeTask{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    taskReady : felt
):
    alloc_locals

    let (lastExecuted) = __lastExecuted.read()
    let (block_timestamp) = get_block_timestamp()
    let deadline = lastExecuted + 60
    let (taskReady) = is_le(deadline, block_timestamp)

    return (taskReady=taskReady)
end

@external
func executeTask{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> ():
    # One could call `probeTask` here; it depends
    # entirely on the application.

    let (counter) = __counter.read()
    let new_counter = counter + 1
    let (b_addr) = contract_B_address.read()
    let (b_num) = contract_B.read_number(b_addr)

    let (block_timestamp) = get_block_timestamp()
    __lastExecuted.write(block_timestamp)
    __counter.write(new_counter)
    return ()
end


# # SPDX-License-Identifier: AGPL-3.0-or-later

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_block_timestamp
from starkware.cairo.common.math_cmp import is_le

@contract_interface
namespace contract_B:
    func increase_balance(number : felt):
    end

    func get_balance() -> (number : felt):
    end
end

#############################################
# #                 STORAGE                 ##
#############################################

@storage_var
func __counter() -> (counter : felt):
end

@storage_var
func __lastExecuted() -> (lastExecuted : felt):
end

#############################################
# #                 GETTERS                 ##
#############################################

@view
func counter{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    counter : felt
):
    let (counter) = __counter.read()
    return (counter)
end

@view
func lastExecuted{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    lastExecuted : felt
):
    let (lastExecuted) = __lastExecuted.read()
    return (lastExecuted)
end

#############################################
# #                  TASK                   ##
#############################################

@view
func probeTask{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    taskReady : felt
):
    alloc_locals

    let (lastExecuted) = __lastExecuted.read()
    let (block_timestamp) = get_block_timestamp()
    let deadline = lastExecuted + 60
    let (taskReady) = is_le(deadline, block_timestamp)

    return (taskReady=taskReady)
end

@external
func executeTask{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> ():
    # One could call `probeTask` here; it depends
    # entirely on the application.

    let (counter) = __counter.read()
    let new_counter = counter + 1
    let (b_addr) = contract_B_address.read()
    let (b_num) = contract_B.read_number(b_addr)

    let (block_timestamp) = get_block_timestamp()
    __lastExecuted.write(block_timestamp)
    __counter.write(new_counter)
    return ()
end

