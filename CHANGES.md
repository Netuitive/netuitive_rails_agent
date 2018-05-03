netuitive_rails_agent 1.2.0 (2016-10-21)
-------------------------
* Added whitelist for tuning action controller collection.

netuitive_rails_agent 1.0.4 (2016-10-21)
-------------------------
* Build improvements, including automatic deployment.
* Added docker example.

netuitive_rails_agent 1.0.3 (2016-10-21)
-------------------------
* error proofing

netuitive_rails_agent 1.0.2 (2016-10-17)
-------------------------
* turning request wrapping off by default
* more fault tolerant if a queue time header isn't included when request wrapping is enabled
* fixed a bug where error metric aren't sent if error events are disabled

netuitive_rails_agent 1.0.1 (2016-10-17)
-------------------------
* refactoring of classes into gem namespace to avoid collisions
* External event support
* Action controller error metrics and events
* Sidekiq metrics and events
* Queue time metrics
* Configurable log properties
* Configurable feature flags
* Request time metrics on the controller and global levels
