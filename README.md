# DB設計

## Usersテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|name|string|null:false|
|email|string|null:false,unique: true|
|avatar|string|
|password|string|null:false,unique: true|
|entry_id|integer|null:false,foreign_key:true|

### Association
has_many :entries
has_many :messages
has_many :lerns
has_many :draftlernings
has_many :follows
has_many :linkes

## Learnsテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|content|string|null:false|
|time|integer|null:false|
|achievement_rate|integer|null:false|
|user_id|integer|null:false,foreign_key:true|
|draft_lerning_id |integer|null:false,foreign_key:true|

### Association
belongs_to :user
belongs_to :draftlerning
has_many   :likes

## Draftlearnsテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|content|string|null:false|
|time|integer|null:false|
|user_id|integer|null:false,foreign_key:true|

### Association
belongs_to : user
has_one    : draftlern

## Likesテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|user_id|integer|null:false,foreign_key:true|
|learn_id|integer|null:false,foreign_key:true|

### Association
belongs_to : user
belongs_to : learn

## Followテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|user_id|integer|null:false,foreign_key:true|
|follow_id|integer|null:false,foreign_key:true|
### Association
has_many : users

## Messagesテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|message|string|null:false|
|user_id|integer|null:false,foreign_key:true|
|room_id|integer|null:false,foreign_key:true|
### Association
belong_to : user
belong_to : room

## Roomsテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|user_id|integer|null:false,foreign_key:true|

### Association
has_many : entries
has_many : messages

## Entriesテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|user_id|integer|null:false,foreign_key:true|
|room_id|integer|null:false,foreign_key:true|

### Association
belong_to : user
belong_to : room
