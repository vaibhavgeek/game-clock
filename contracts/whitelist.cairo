# # SPDX-License-Identifier: AGPL-3.0-or-later

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_block_timestamp
from starkware.cairo.common.math_cmp import is_le

# # @title Example Whitelist task.
# # @description Create a secret key and allow it to access a smart contract function.
# # @author vaibhavgeek <github.com/vaibhavgeek>

#############################################
# #                 STORAGE                 ##
#############################################

@storage_var
func __whitelist(address : felt) -> (res : felt):
end

@storage_var
func __secrets(secret : felt) -> (res : felt):
end

@storage_var
func __owner() -> (owner_address : felt):
end

@constructor
func constructor{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}(owner_address : felt):
    __owner.write(value=owner_address)
    return ()
end
#############################################
# #                 GETTERS                 ##
#############################################

@external
func get_secret{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        counter : felt):
    let (user) = get_caller_address()
    let (block_timestamp) = get_block_timestamp()
    let (counter) = __whitelist.read(address=)
    return (counter)
end

@view
func lastExecuted{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        lastExecuted : felt):
    let (lastExecuted) = __lastExecuted.read()
    return (lastExecuted)
end

#############################################
# #                  TASK                   ##
#############################################

@view
func probeTask{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        taskReady : felt):
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
    let (block_timestamp) = get_block_timestamp()
    __lastExecuted.write(block_timestamp)
    __counter.write(new_counter)
    return ()
end
