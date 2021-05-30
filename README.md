# DB設計

## Usersテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|name|string|null:false|
|email|string|null:false,unique: true|
|avatar|string|
|admin|boolean|default: false|
|password|string|null:false,unique: true|
|entry_id|integer|null:false,foreign_key:true|

### Association
has_many :entries <br>
has_many :messages<br>
has_many :lerns<br>
has_many :draftlernings<br>
has_many :likes <br>
has_many :relationships <br>
has_many :followings, through: :relationships, source: :follow <br>
has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id' <br>
has_many :followers, through: :reverse_of_relationships, source: :user <br>
has_many :reads
<!-- has_many :notifications -->

## Learnsテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|content|string|null:false|
|time|integer|null:false|
|achievement_rate|integer|null:false|
|user_id|integer|null:false,foreign_key:true|
|draft_lern_id |integer|null:false,foreign_key:true|

### Association
belongs_to :user<br>
belongs_to :draftlerning<br>
has_many   :likes

## Draftlearnsテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|content|string|null:false|
|time|integer|null:false|
|user_id|integer|null:false,foreign_key:true|

### Association
belongs_to : user <br>
has_one    : draftlern

## Likesテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|user_id|integer|null:false,foreign_key:true|
|learn_id|integer|null:false,foreign_key:true|
|draft_learn_id|integer|null:false,foregin_key:true|
### Association
belongs_to : user <br>
belongs_to : learn<br>
belongs_to : draft_learn

## Relationshipsテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|user_id|integer|null:false,foreign_key:true|
|follow_id|integer|null:false,foreign_key:true|
### Association
belongs_to :user <br>
belongs_to :follow, class_name: 'User'

## Messagesテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|message|string|null:false|
|user_id|integer|null:false,foreign_key:true|
|room_id|integer|null:false,foreign_key:true|
### Association
belong_to : user <br>
belong_to : room <br>
has_many   : messages

## Roomsテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|user_id|integer|null:false,foreign_key:true|

### Association
has_many : entries <br>
has_many : messages

## Entriesテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|user_id|integer|null:false,foreign_key:true|
|room_id|integer|null:false,foreign_key:true|

### Association
belong_to : user <br>
belong_to : room

### Readsテーブル
Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|user_id|integer|null:false,foreign_key:true|
|message_id|integer|null:false,foreign_key:true|

### Association
belong_to : user <br>
belong_to : message

<!-- ### Notificationsテーブル
Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|action|string|null:false|
|checked|boolean|null:false|
|sender_id|integer|null:false|
|receiver_id|integer|null:false|
|like_id|integer|null:false,foreign_key:true,optional: true|
|follow_id|integer|null:false,foreign_key:true,optional: true|
|message_id|integer|null:false,foreign_key:true,optional: true|
### Association
belong_to : user <br>
belong_to : message<br>
belong_to : like<br>
belong_to : relationship -->
