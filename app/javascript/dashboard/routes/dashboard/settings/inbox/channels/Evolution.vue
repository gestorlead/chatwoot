<script>
import { mapGetters } from 'vuex';
import { useVuelidate } from '@vuelidate/core';
import { useAlert } from 'dashboard/composables';
import { required } from '@vuelidate/validators';
import router from '../../../../index';
import { isPhoneE164OrEmpty } from 'shared/helpers/Validators';

export default {
  setup() {
    return { v$: useVuelidate() };
  },
  data() {
    return {
      phoneNumber: '',
      ignoreGroups: true,
      signMessages: true,
      reopenConversations: false,
    };
  },
  computed: {
    ...mapGetters({ uiFlags: 'inboxes/getUIFlags' }),
  },
  validations: {
    phoneNumber: { required, isPhoneE164OrEmpty },
  },
  methods: {
    async createChannel() {
      this.v$.$touch();
      if (this.v$.$invalid) {
        return;
      }

      try {
        const whatsappChannel = await this.$store.dispatch(
          'inboxes/createEvolutionChannel',
          {
            name: this.phoneNumber.replace(/\D/g, ''),
            channel: {
              type: 'api',
              ignoreGroups: this.ignoreGroups,
              signMessages: this.signMessages,
              reopenConversations: this.reopenConversations,
            },
          }
        );

        router.replace({
          name: 'settings_inboxes_add_agents',
          params: {
            page: 'new',
            inbox_id: whatsappChannel.id,
          },
        });
      } catch (error) {
        useAlert(
          error.message || this.$t('INBOX_MGMT.ADD.WHATSAPP.API.ERROR_MESSAGE')
        );
      }
    },
  },
};
</script>

<template>
  <form class="flex flex-wrap mx-0" @submit.prevent="createChannel()">
    <div class="w-[65%] flex-shrink-0 flex-grow-0 max-w-[65%]">
      <label :class="{ error: v$.phoneNumber.$error }">
        {{ $t('INBOX_MGMT.ADD.WHATSAPP.PHONE_NUMBER.LABEL') }}
        <input
          v-model.trim="phoneNumber"
          type="text"
          :placeholder="$t('INBOX_MGMT.ADD.WHATSAPP.PHONE_NUMBER.PLACEHOLDER')"
          @blur="v$.phoneNumber.$touch"
        />
        <span v-if="v$.phoneNumber.$error" class="message">
          {{ $t('INBOX_MGMT.ADD.WHATSAPP.PHONE_NUMBER.ERROR') }}
        </span>
      </label>
    </div>
    
    <div class="w-full mt-3">
      <h4 class="text-base font-medium mb-2">{{ $t('INBOX_MGMT.SETTINGS') }}</h4>
      
      <div class="mb-2">
        <woot-toggle-button
          v-model="ignoreGroups"
          :label="$t('INBOX_MGMT.ADD.WHATSAPP.SETTINGS.IGNORE_GROUPS')"
        />
      </div>
      
      <div class="mb-2">
        <woot-toggle-button
          v-model="signMessages"
          :label="$t('INBOX_MGMT.ADD.WHATSAPP.SETTINGS.SIGN_MESSAGES')"
        />
      </div>
      
      <div class="mb-4">
        <woot-toggle-button
          v-model="reopenConversations"
          :label="$t('INBOX_MGMT.ADD.WHATSAPP.SETTINGS.REOPEN_CONVERSATIONS')"
        />
      </div>
    </div>
    
    <div class="w-full">
      <woot-submit-button
        :loading="uiFlags.isCreating"
        :button-text="$t('INBOX_MGMT.ADD.WHATSAPP.SUBMIT_BUTTON')"
      />
    </div>
  </form>
</template>
